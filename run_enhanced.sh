#!/bin/bash

set -e # Exit on error
START_TR=${1:-0}
START_EXP=${2:-1}
ONLY_EXP=${3:-}

# Enhanced configuration with retry settings
MAX_RETRIES=3
RETRY_DELAY=10
TIMEOUT_GNURADIO=10
TIMEOUT_UE_CONNECTION=10
TIMEOUT_SERVICE_READY=10
HEALTH_CHECK_INTERVAL=5
METRICS_503_CHECK_TIMEOUT=10

if ! [[ "$START_TR" =~ ^[0-9]+$ && "$START_EXP" =~ ^[0-9]+$ ]]; then
    error "Usage: $0 [start_training_set] [start_experiment_number]"
    exit 1
fi

# --- Configuration ---
BASE_DIR="${PWD}"
CSV_FILE="${BASE_DIR}/dataset/ue_data.csv"
GNB_CONF="${BASE_DIR}/openran/my-srsproject-demo/multi-ue-setup/gnb_zmq.yaml"
UE_CONF="${BASE_DIR}/openran/my-srsproject-demo/multi-ue-setup/ue1_zmq.conf"
METRICS_IP="127.0.0.1"
RIC_IP="127.0.0.1"
AMF_IP="10.53.1.2"
TOTAL_TRAINING_SETS=100
TOTAL_EXPERIMENTS=1
BASE_EXP_DIR="${BASE_DIR}/dataset/generated_malicious_experiments"
BASE_IP="10.45.1.2"
CURRENT_RUN=$((START_TR * TOTAL_EXPERIMENTS + START_EXP - 1))
CURRENT_TR=$START_TR
CURRENT_EXP=$START_EXP
TOTAL_RUNS=$((TOTAL_TRAINING_SETS * TOTAL_EXPERIMENTS))
EXPECTED_DURATION_SEC=480

# Global variables for tracking retry state
declare -A RETRY_COUNTS
EXPERIMENT_STATE_FILE="/tmp/experiment_state.json"

# --- Animated Progress Bar Functions ---
print_main_progress_bar() {
    local progress=$1
    local total=$2
    local bar_width=40
    local filled=$((progress * bar_width / total))
    local empty=$((bar_width - filled))
    local percent=$((progress * 100 / total))
    local spin='-\|/'
    local spinner_index=$((progress % 4))
    local spinner_char=${spin:spinner_index:1}

    tput sc                                # Save cursor position
    tput cup $(($(tput lines) - 1)) 0      # Move to bottom line
    tput el                                # Clear the line

    printf "Overall Progress: [%s] " "$spinner_char"
    printf "\e[32m"                        # Green bar
    printf "%0.s#" $(seq 1 $filled)
    printf "\e[0m"                         # Reset color
    printf "%0.s-" $(seq 1 $empty)
    printf " %d%% (%d/%d)" "$percent" "$progress" "$total"

    tput rc                                # Restore cursor position
    tput cnorm                             # Restore cursor visibility
    echo -ne "\r"                          # Return to start of line
}


run_sleep_with_progress() {
    local duration=$1
    local message=$2
    local width=40
    local spin='-\|/'

    tput civis # Hide cursor
    for i in $(seq 1 $duration); do
        local percent=$((i * 100 / duration))
        local filled=$((i * width / duration))
        local empty=$((width - filled))
        local spinner_char=${spin:i%4:1}

        # Use \r to stay on the same line
        printf "\r%s [%s] " "$message" "$spinner_char"
        printf "%0.s#" $(seq 1 $filled)
        printf "%0.s-" $(seq 1 $empty)
        printf " %d%% (%ds/%ds)" "$percent" "$i" "$duration"
        sleep 1
    done
    tput cnorm # Restore cursor
    echo "" # Print a newline at the end
}


# --- Enhanced Output Formatting ---
info() { echo -ne "\n🔵 \033[1;34m$*\033[0m"; }
success() { echo -e "\n✅ \033[1;32m$*\033[0m"; }
warn() { echo -e "\n⚠️  \033[1;33m$*\033[0m"; }
error() { echo -e "\n❌ \033[1;31m$*\033[0m"; }
step() { echo -e "\n🔷 \033[1;36m$*\033[0m"; }
retry_info() { echo -e "\n🔄 \033[1;35m$*\033[0m"; }

# --- State Management Functions ---
save_experiment_state() {
    local tr=$1
    local exp=$2
    local step=$3
    local retry_count=$4
    cat > "$EXPERIMENT_STATE_FILE" << EOF
{
    "training_set": $tr,
    "experiment": $exp,
    "step": "$step",
    "retry_count": $retry_count,
    "timestamp": "$(date -Iseconds)"
}
EOF
}

load_experiment_state() {
    if [[ -f "$EXPERIMENT_STATE_FILE" ]]; then
        cat "$EXPERIMENT_STATE_FILE"
    else
        echo "{}"
    fi
}

# --- Enhanced Health Check Functions ---
check_docker_service_health() {
    local service_name=$1
    local timeout=${2:-$TIMEOUT_SERVICE_READY}
    local start_time=$(date +%s)
    
    info "Checking health of Docker service: $service_name (timeout: ${timeout}s)"
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if (( elapsed >= timeout )); then
            error "Timeout waiting for $service_name to be healthy"
            return 1
        fi
        
        local health_status
        case "$service_name" in
            "ric_submgr")
                if sudo docker logs ric_submgr 2>&1 | grep -q 'RMR is ready now ...'; then
                    success "$service_name is ready"
                    return 0
                fi
                ;;
            "open5gs_5gc")
                health_status=$(sudo docker inspect --format='{{json .State.Health.Status}}' open5gs_5gc 2>/dev/null || echo '"unknown"')
                if [[ "$health_status" == '"healthy"' ]]; then
                    success "$service_name is healthy"
                    return 0
                fi
                ;;
        esac
        
        echo -n "."
        sleep $HEALTH_CHECK_INTERVAL
    done
}

check_port_availability() {
    local port=$1
    local max_attempts=5
    local attempt=1
    
    while (( attempt <= max_attempts )); do
        if ! lsof -i :$port >/dev/null 2>&1; then
            return 0
        fi
        
        warn "Port $port is in use (attempt $attempt/$max_attempts). Attempting to free it..."
        local pid=$(lsof -ti :$port 2>/dev/null || true)
        if [[ -n "$pid" ]]; then
            info "Killing process using port $port (PID: $pid)"
            sudo kill -9 "$pid" 2>/dev/null || true
            sleep 2
        fi
        
        ((attempt++))
    done
    
    error "Failed to free port $port after $max_attempts attempts"
    return 1
}

# --- Enhanced Cleanup Function ---
cleanup() {
    local tr=${1:-$CURRENT_TR}
    local exp=${2:-$CURRENT_EXP}
    local exp_dir="${BASE_EXP_DIR}/tr${tr}/exp${exp}"
    
    info "Starting comprehensive cleanup for Training Set: $tr, Experiment: $exp"
    step "--- 🧹 Enhanced Graceful Shutdown ---"
    
    # Stop background processes with better error handling
    info "Stopping background processes..."
    
    # Stop GNU Radio
    if [[ -n "${GNURADIO_PID:-}" && -e /proc/${GNURADIO_PID} ]]; then
        info "Stopping GNU Radio (PID: $GNURADIO_PID)"
        kill "$GNURADIO_PID" 2>/dev/null || true
        sleep 2
        if kill -0 "$GNURADIO_PID" 2>/dev/null; then
            warn "GNU Radio still running, force killing..."
            kill -9 "$GNURADIO_PID" 2>/dev/null || true
        fi
    fi
    
    # Stop iPerf processes
    for i in {1..3}; do
        local pid_file="/tmp/iperf_UE${i}.pid"
        if [[ -f "$pid_file" ]]; then
            local iperf_pid=$(cat "$pid_file")
            if kill -0 "$iperf_pid" 2>/dev/null; then
                info "Stopping iPerf UE${i} (PID: $iperf_pid)"
                kill "$iperf_pid" 2>/dev/null || true
            fi
            rm -f "$pid_file"
        fi
    done
    
    # Stop metrics server
    if [[ -f /tmp/metrics_server.pid ]]; then
        local metrics_pid=$(cat /tmp/metrics_server.pid)
        if ps -p $metrics_pid > /dev/null 2>&1; then
            info "Stopping metrics server (PID: $metrics_pid)"
            sudo kill $metrics_pid 2>/dev/null || true
        fi
        rm -f /tmp/metrics_server.pid
    fi
    
    # Kill tmux sessions with retries
    info "Stopping tmux sessions..."
    local tmux_sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null || true)
    if [[ -n "$tmux_sessions" ]]; then
        echo "$tmux_sessions" | while read -r session; do
            if [[ -n "$session" ]]; then
                info "Killing tmux session: $session"
                tmux kill-session -t "$session" 2>/dev/null || true
            fi
        done
    fi
    tmux kill-server 2>/dev/null || true
    
    # Enhanced Docker cleanup with parallel execution and timeouts
    info "Stopping Docker services..."
    (
        cd "${BASE_DIR}/openran/oran-sc-ric"
        timeout 30s sudo docker compose down -v --remove-orphans > /dev/null 2>&1 || {
            warn "RIC docker compose down timed out, force stopping containers"
            sudo docker stop $(sudo docker ps -q --filter "name=ric") 2>/dev/null || true
        }
    ) &
    
    (
        cd "${BASE_DIR}/openran/srsRAN_Project/docker"
        timeout 30s sudo docker compose down -v --remove-orphans > /dev/null 2>&1 || {
            warn "srsRAN docker compose down timed out, force stopping containers"
            sudo docker stop $(sudo docker ps -q --filter "name=open5gs") 2>/dev/null || true
        }
    ) &
    
    wait || true
    
    # Clean up network namespaces with verification
    info "Cleaning up network namespaces..."
    for i in {1..3}; do
        local ns="ue$i"
        if ip netns list 2>/dev/null | grep -q "^${ns}$"; then
            info "Deleting namespace: $ns"
            sudo ip netns delete "$ns" 2>/dev/null || warn "Failed to delete namespace $ns"
        fi
    done
    
    # Enhanced process cleanup
    info "Cleaning up remaining processes..."
    sudo pkill -f "sudo gnb" 2>/dev/null || true
    sudo pkill -f "sudo srsue" 2>/dev/null || true
    sudo pkill -f "python.*scenario" 2>/dev/null || true
    
    # ZMQ port cleanup with enhanced verification
    info "Cleaning up ZMQ ports..."
    for port in 2000 2001 2100 2101 2200 2201 2300 2301 55555; do
        if lsof -i :$port >/dev/null 2>&1; then
            local pid=$(lsof -ti :$port 2>/dev/null || true)
            if [[ -n "$pid" ]]; then
                info "Killing process using port $port (PID: $pid)"
                sudo kill -9 "$pid" 2>/dev/null || true
                sleep 1
            fi
        fi
    done
    
    # Clean up temporary files with pattern matching
    info "Cleaning up temporary files..."
    sudo rm -f /tmp/ue* /tmp/cu_cp* /tmp/python_scenario.pid /tmp/iperf_*.pid /tmp/metrics_server.pid
    sudo rm -f ${exp_dir}/gnb_logs/*.log
    # Network route cleanup
    if ip route show | grep -q "10.45.0.0/16 via 10.53.1.2"; then
        info "Removing network route"
        sudo ip route del 10.45.0.0/16 via 10.53.1.2 2>/dev/null || true
    fi
    
    success "Enhanced cleanup complete"
}

# Enhanced trap function
trap 'cleanup; exit 130' INT TERM
trap 'cleanup'  EXIT

# --- Robust Retry Wrapper Function ---
retry_with_backoff() {
    local max_attempts=$1
    local delay=$2
    local step_name=$3
    shift 3
    local command=("$@")
    
    for attempt in $(seq 1 $max_attempts); do
        retry_info "Attempting $step_name (attempt $attempt/$max_attempts)"
        
        if "${command[@]}"; then
            success "$step_name succeeded on attempt $attempt"
            return 0
        else
            local exit_code=$?
            if (( attempt < max_attempts )); then
                warn "$step_name failed on attempt $attempt (exit code: $exit_code)"
                retry_info "Waiting ${delay}s before retry..."
                sleep $delay
                # Exponential backoff
                delay=$((delay * 2))
            else
                error "$step_name failed after $max_attempts attempts (final exit code: $exit_code)"
                return $exit_code
            fi
        fi
    done
}

# --- Enhanced ZMQ Port Management ---
check_and_free_zmq_ports() {
    info "Performing comprehensive ZMQ port check..."
    local ports=(2000 2001 2100 2101 2200 2201)
    local failed_ports=()
    
    for port in "${ports[@]}"; do
        if ! check_port_availability "$port"; then
            failed_ports+=("$port")
        fi
    done
    
    if (( ${#failed_ports[@]} > 0 )); then
        error "Failed to free ports: ${failed_ports[*]}"
        return 1
    fi
    
    success "All ZMQ ports are available: ${ports[*]}"
    return 0
}

# --- Enhanced Connection Waiting Functions ---
wait_for_gnb_connection() {
    local name=$1
    local log_dir=$2
    local timeout=${3:-$TIMEOUT_SERVICE_READY}
    local log_file="${log_dir}/${name}.log"
    local start_time=$(date +%s)
    
    info "Waiting for $name to establish connections (timeout: ${timeout}s)"
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if (( elapsed >= timeout )); then
            error "Timeout waiting for $name connections"
            if [[ -f "$log_file" ]]; then
                error "Last 20 lines from $log_file:"
                tail -n 20 "$log_file" | sed 's/^/    /'
            fi
            return 1
        fi
        
        if [[ ! -f "$log_file" ]]; then
            info "Waiting for log file to be created..."
            sleep 2
            continue
        fi
        
        local n2_ready=false
        local e2_ready=false
        
        if grep -q "N2: Connection to AMF on $AMF_IP:38412 was established" "$log_file"; then
            n2_ready=true
        fi
        
        if grep -q "E2AP: E2 connection to Near-RT-RIC on $RIC_IP:36421 accepted" "$log_file"; then
            e2_ready=true
        fi
        
        printf "\rConnection status -> N2: %s, E2: %s (elapsed: %ds)" \
               "$n2_ready" "$e2_ready" "$elapsed"
        
        if [[ "$n2_ready" == true && "$e2_ready" == true ]]; then
            echo ""
            success "$name connected successfully"
            return 0
        fi
        
        sleep 2
    done
}

wait_for_ue_connection() {
    local ue_id=$1
    local log_dir=$2
    local timeout=${3:-$TIMEOUT_UE_CONNECTION}
    local ue_ns="ue${ue_id}"
    local log_file="${log_dir}/${ue_ns}_stdout.log"
    local start_time=$(date +%s)
    
    info "Waiting for UE${ue_id} to connect (timeout: ${timeout}s)"
    
    # Wait for log file creation
    local file_wait_timeout=30
    local file_wait_start=$(date +%s)
    while [[ ! -f "$log_file" ]]; do
        local file_wait_elapsed=$(( $(date +%s) - file_wait_start ))
        if (( file_wait_elapsed >= file_wait_timeout )); then
            error "Log file ${log_file} not created within ${file_wait_timeout}s"
            return 1
        fi
        sleep 1
    done
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if (( elapsed >= timeout )); then
            error "Timeout waiting for UE${ue_id} to connect"
            error "Last 15 lines from ${log_file}:"
            tail -n 15 "$log_file" | sed 's/^/    /'
            return 1
        fi
        
        local pdu_ready=false
        local rrc_ready=false
        
        if grep -q "PDU Session Establishment successful. IP:" "$log_file"; then
            pdu_ready=true
        fi
        
        if grep -q "RRC NR reconfiguration successful" "$log_file"; then
            rrc_ready=true
        fi
        
        printf "\rUE${ue_id} Status -> PDU: %s, RRC: %s (elapsed: %ds)" \
               "$pdu_ready" "$rrc_ready" "$elapsed"
        
        if [[ "$pdu_ready" == true && "$rrc_ready" == true ]]; then
            echo ""
            success "UE${ue_id} connected successfully"
            return 0
        fi
        
        sleep 2
    done
}

# --- Enhanced Service Start Functions ---
start_gnb() {
    local name=$1
    local id=$2
    local bind_ip=$3
    local metrics_port=$4
    local log_dir=$5
    local tx_port=$(((id + 1) * 1000))
    local rx_port=$(((id + 1) * 1000 + 1))
    
    info "Starting gNB: $name (ID: $id, IP: $bind_ip, Metrics: $metrics_port)"
    
    # Check metrics port availability
    if ! check_port_availability "$metrics_port"; then
        error "Cannot start gNB - metrics port $metrics_port unavailable"
        return 1
    fi
    
    # Start metrics server with better error handling
    info "Starting metrics server on port $metrics_port"
    python3 "${BASE_DIR}/metrics_server.py" \
        -f "${log_dir}/${name}_metrics.jsonl" \
        -p "$metrics_port" > /dev/null 2>&1 &
    
    local metrics_server_pid=$!
    echo $metrics_server_pid > /tmp/metrics_server.pid
    
    # Wait for metrics server to be ready
    local wait_count=0
    while ! lsof -i :"$metrics_port" | grep -q python3; do
        if (( wait_count >= 30 )); then
            error "Metrics server failed to start within 30 seconds"
            kill $metrics_server_pid 2>/dev/null || true
            return 1
        fi
        sleep 1
        ((wait_count++))
    done
    
    success "Metrics server ready on port $metrics_port"
    
    # Check bind IP availability
    if ss -tuln | grep -q "$bind_ip"; then
        warn "Bind IP $bind_ip is in use, attempting to free it"
        local pids=$(sudo lsof -nP -iUDP@"$bind_ip" | awk 'NR>1 {print $2}' | sort -u)
        for pid in $pids; do
            if [[ -n "$pid" ]]; then
                info "Killing process with PID $pid using $bind_ip"
                sudo kill "$pid" 2>/dev/null || true
            fi
        done
        sleep 2
    fi
    
    # Kill existing tmux session
    if tmux has-session -t "gnb_${name}" 2>/dev/null; then
        warn "Existing gNB session found, terminating it"
        tmux kill-session -t "gnb_${name}" 2>/dev/null || true
        sleep 2
    fi
    
    # Start gNB in tmux session
    tmux new-session -d -s "gnb_${name}" "sudo gnb -c $GNB_CONF \
        --ran_node_name $name \
        --gnb_id 411 \
        --gnb_cu_up_id 0 \
        --gnb_du_id 0 \
        cu_cp \
        amf \
        --bind_addr $bind_ip \
        ru_sdr \
        --device_args tx_port=tcp://127.0.0.1:${tx_port},rx_port=tcp://127.0.0.1:${rx_port},base_srate=11.52e6 \
        log \
        --filename ${log_dir}/${name}.log \
        --e1ap_json_enabled true \
        --f1ap_json_enabled true \
        --high_latency_diagnostics_enabled true \
        --broadcast_enabled true \
        --radio_level warning \
        --hex_max_size 1024 \
        trace \
        --filename ${log_dir}/${name}_tracing.log \
        pcap \
        --mac_enable true \
        --mac_filename ${log_dir}/${name}_mac.pcap \
        --mac_type udp \
        --ngap_enable true \
        --ngap_filename ${log_dir}/${name}_ngap.pcap \
        --e2ap_enable true \
        --e2ap_du_filename ${log_dir}/${name}_du_e2ap.pcap \
        --e2ap_cu_cp_filename ${log_dir}/${name}_cu_cp_e2ap.pcap \
        --e2ap_cu_up_filename ${log_dir}/${name}_cu_up_e2ap.pcap \
        --rlc_enable true \
        --rlc_filename ${log_dir}/${name}_rlc.pcap \
        --rlc_rb_type all \
        --e1ap_enable true \
        --e1ap_filename ${log_dir}/${name}_e1ap.pcap \
        --f1ap_enable true \
        --f1ap_filename ${log_dir}/${name}_f1ap.pcap \
        --f1u_enable true \
        --f1u_filename ${log_dir}/${name}_f1u.pcap \
        --n3_enable true \
        --n3_filename ${log_dir}/${name}_n3.pcap \
        # metrics \
        #--addr ${METRICS_IP} \
        # --port ${metrics_port} \
        < /dev/null > ${log_dir}/${name}_stdout.log 2>&1"
    
    success "gNB $name started successfully"
    sleep 5
    
    # Wait for gNB connections with retry
    if ! wait_for_gnb_connection "$name" "$log_dir" 180; then
        error "gNB $name failed to establish connections"
        return 1
    fi
    
    return 0
}

start_ue() {
    local i=$1
    local log_dir=$2
    local ue_ns="ue$i"
    local ue_ip=$(echo "$BASE_IP" | awk -F. -v OFS=. -v i="$i" '{$4 += (i - 1); print}')
    local group=$(((i - 1) / 3))
    local offset=$((((i - 1) % 3) * 100))
    local tx_port=$((2101 + group * 1000 + offset))
    local rx_port=$((2100 + group * 1000 + offset))
    
    # Read UE configuration from CSV
    local line=$(awk -F',' 'BEGIN{c=0} !/^#/ && NF{c++; if(c=='"$i"') print $0}' "$CSV_FILE")
    if [[ -z "$line" ]]; then
        error "No UE entry found at index $i in $CSV_FILE"
        return 1
    fi
    
    IFS=',' read -r name imsi key imei <<< "$line"
    info "Starting UE $i: $name (IMSI: $imsi, IMEI: $imei)"
    info "Network: $ue_ns, IP: $ue_ip, TX: $tx_port, RX: $rx_port"
    
    # Kill existing session
    if tmux has-session -t "ue$i" 2>/dev/null; then
        warn "Existing UE$i session found, terminating it"
        tmux kill-session -t "ue$i" 2>/dev/null || true
        sleep 2
    fi
    
    # Start UE in tmux session
    tmux new-session -d -s "ue$i" "sudo srsue ${UE_CONF} \
        --gw.netns $ue_ns \
        --rf.device_args tx_port=tcp://127.0.0.1:$tx_port,rx_port=tcp://127.0.0.1:$rx_port,base_srate=11.52e6 \
        --usim.imsi $imsi \
        --usim.k $key \
        --usim.imei $imei \
        --log.all_level warning \
        --log.filename ${log_dir}/ue$i.log \
        --pcap.enable mac,mac_nr,nas \
        --pcap.mac_filename ${log_dir}/${ue_ns}_mac.pcap \
        --pcap.mac_nr_filename ${log_dir}/${ue_ns}_mac_nr.pcap \
        --pcap.nas_filename ${log_dir}/${ue_ns}_nas.pcap \
        --general.metrics_csv_enable 1 \
        --general.metrics_csv_filename ${log_dir}/${ue_ns}_metrics.csv \
        --general.tracing_enable 1 \
        --general.tracing_filename ${log_dir}/${ue_ns}_tracing.log \
        --stack.have_tti_time_stats 1 > ${log_dir}/${ue_ns}_stdout.log 2>&1"
    
    success "UE $i started in namespace $ue_ns"
    return 0
}

# --- Enhanced iPerf Management ---
start_and_wait_for_iperf() {
    local conditions_file="$1"
    local max_ues="$2"
    local exp_dir="$3"
    local all_started=true
    
    if [[ ! -f "$conditions_file" ]]; then
        error "Conditions file not found: $conditions_file"
        return 1
    fi
    
    info "Starting iPerf traffic generation for up to $max_ues UEs"
    
    local counter=0
    local iperf_pids=()
    
    while IFS=',' read -r ue iperf_path; do
        [[ "$ue" == "UE" ]] && continue
        
        ((counter++))
        if (( counter > max_ues )); then break; fi
        
        local ns_name=$(echo "$ue" | tr '[:upper:]' '[:lower:]')
        local pid_file="/tmp/iperf_${ue}.pid"
        local port=$((5200 + counter))
        
        if [[ ! -f "$iperf_path" ]]; then
            warn "iPerf script not found: $iperf_path for $ue. Skipping..."
            continue
        fi
        
        info "Starting iPerf for $ue in namespace $ns_name (port: $port)"
        
        # Enhanced iPerf execution with better error handling
        sudo ip netns exec "$ns_name" bash -c "'$iperf_path' '$port'" \
           > "${exp_dir}/${ue}_iperf.log" 2>&1 &
        local last_pid=$!
        
        # Check if the process started successfully
        if kill -0 "$last_pid" 2>/dev/null; then
            echo "$last_pid" > "$pid_file"
            iperf_pids+=($last_pid)
            success "iPerf for $ue started (PID: $last_pid)"
        else
            all_started=false
            error "Failed to start iPerf for $ue"
        fi
        
    done < "$conditions_file"
    if [[ "$all_started" == "false" ]]; then
        error "One or more iPerf processes failed to start. Aborting."
        for pid in "${iperf_pids[@]}"; do kill "$pid" 2>/dev/null || true; done
        return 1
    fi
    if (( ${#iperf_pids[@]} > 0 )); then
        info "Waiting for traffic generation to complete (${EXPECTED_DURATION_SEC}s)"
        run_sleep_with_progress $EXPECTED_DURATION_SEC "Traffic Generation"
        success "Traffic generation completed"
    else
        warn "No iPerf processes were started"
    fi
    
    return 0
}

# --- Enhanced Metrics Monitoring ---
check_metrics_503_error() {
    local metrics_log_file="$1"
    local timeout=${2:-$METRICS_503_CHECK_TIMEOUT}
    local start_time=$(date +%s)
    
    info "Monitoring metrics for 503 errors (timeout: ${timeout}s)"
    
    while true; do
        local elapsed=$(( $(date +%s) - start_time ))
        if (( elapsed >= timeout )); then
            break
        fi
        
        if [[ -f "$metrics_log_file" ]] && grep -q "503" "$metrics_log_file"; then
            error "Detected 503 error in metrics output"
            return 1
        fi
        
        sleep 2
    done
    
    success "No 503 errors detected in metrics"
    return 0
}

# --- Enhanced Experiment Validation ---
validate_experiment_completion() {
    local exp_dir="$1"
    local tr_num="$2"
    local exp_num="$3"
    local metrics_csv="${exp_dir}/metrics/kpm_style5_metrics.csv"
    
    info "Validating experiment completion for tr${tr_num}/exp${exp_num}"
    
    if [[ ! -f "$metrics_csv" ]]; then
        warn "Metrics CSV not found: $metrics_csv"
        return 1
    fi
    
    # Check if CSV has data
    local line_count=$(wc -l < "$metrics_csv")
    if (( line_count <= 1 )); then
        warn "Metrics CSV appears empty (only header)"
        return 1
    fi
    
    # Validate duration
    local header=$(head -n 1 "$metrics_csv")
    IFS=',' read -ra columns <<< "$header"
    local ts_index=-1
    
    for i in "${!columns[@]}"; do
        if [[ "${columns[$i]}" == "Timestamp" ]]; then
            ts_index=$i
            break
        fi
    done
    
    if [[ $ts_index -eq -1 ]]; then
        warn "Timestamp column not found in metrics CSV"
        return 1
    fi
    
    # Extract and validate timestamps
    local timestamps=()
    while IFS= read -r line; do
        local ts=$(echo "$line" | cut -d',' -f$((ts_index+1)))
        timestamps+=("$ts")
    done < <(tail -n +2 "$metrics_csv")
    
    if (( ${#timestamps[@]} == 0 )); then
        warn "No timestamp data found in metrics CSV"
        return 1
    fi
    
    # Convert timestamps to epoch and calculate duration
    local epoch_times=()
    local parse_error=0
    
    for ts in "${timestamps[@]}"; do
        local epoch=$(date -d "$ts" +"%s" 2>/dev/null)
        if [[ -z "$epoch" ]]; then
            parse_error=1
            break
        fi
        epoch_times+=("$epoch")
    done
    
    if (( parse_error )); then
        warn "Failed to parse some timestamps in metrics CSV"
        return 1
    fi
    
    local min_epoch=${epoch_times[0]}
    local max_epoch=${epoch_times[0]}
    
    for e in "${epoch_times[@]}"; do
        (( e < min_epoch )) && min_epoch=$e
        (( e > max_epoch )) && max_epoch=$e
    done
    
    local duration=$((max_epoch - min_epoch))
    info "Experiment duration: ${duration}s (expected: ${EXPECTED_DURATION_SEC}s)"
    
    if (( duration >= EXPECTED_DURATION_SEC - 10 && duration <= EXPECTED_DURATION_SEC + 10 )); then
        success "Experiment duration is within acceptable range"
        return 0
    else
        warn "Experiment duration ${duration}s is outside expected range"
        return 1
    fi
}

# --- Enhanced Main Experiment Loop ---
run_single_experiment() {
    local tr_num=$1
    local exp_num=$2
    local retry_count=${3:-0}
    
    local exp_dir="${BASE_EXP_DIR}/tr${tr_num}/exp${exp_num}"
    local conditions_file="${exp_dir}/conditions.csv"
    local run_scenario_sh="${exp_dir}/run_scenario.sh"
    local metrics_log_file="${exp_dir}/metrics_output_tr${tr_num}_exp${exp_num}.log"
    local metrics_csv="${exp_dir}/metrics/kpm_style5_metrics.csv"
    
    info "Starting experiment tr${tr_num}/exp${exp_num} (attempt $((retry_count + 1)))"
    save_experiment_state "$tr_num" "$exp_num" "starting" "$retry_count"
    
    # Validate required files exist
    if [[ ! -f "$conditions_file" ]]; then
        error "Conditions file not found: $conditions_file"
        return 1
    fi
    
    if [[ ! -f "$run_scenario_sh" ]]; then
        error "Scenario script not found: $run_scenario_sh"
        return 1
    fi
    
    # Skip if already completed successfully
    # if validate_experiment_completion "$exp_dir" "$tr_num" "$exp_num"; then
        # success "Experiment tr${tr_num}/exp${exp_num} already completed successfully"
        # return 0
    # fi
    
    # Create necessary directories
    mkdir -p "${exp_dir}/gnb_logs" "${exp_dir}/ue_logs" "${exp_dir}/metrics"
    
    # Step 1: Start Near-RT RIC
    step "[1/6] Starting Near-RT RIC"
    save_experiment_state "$tr_num" "$exp_num" "ric_starting" "$retry_count"
    
    cd "${BASE_DIR}/openran/oran-sc-ric"
    if ! retry_with_backoff 3 10 "RIC startup" \
         sudo env METRICS_PATH="${exp_dir}/metrics" docker compose up -d; then
        error "Failed to start Near-RT RIC"
        return 1
    fi
    
    if ! check_docker_service_health "ric_submgr"; then
        error "Near-RT RIC failed to become ready"
        return 1
    fi
    
    # Step 2: Start Open5GS Core
    step "[2/6] Starting Open5GS Core"
    save_experiment_state "$tr_num" "$exp_num" "5gc_starting" "$retry_count"
    
    cd "${BASE_DIR}/openran/srsRAN_Project/docker"
    if ! retry_with_backoff 3 10 "5GC startup" \
         sudo docker compose up -d; then
        error "Failed to start Open5GS Core"
        return 1
    fi
    
    if ! check_docker_service_health "open5gs_5gc" 180; then
        error "Open5GS Core failed to become healthy"
        return 1
    fi
    
    # Start iPerf servers in 5GC
    step "Starting iPerf servers in 5GC"
    for port in 5201 5202 5203; do
        if ! docker exec -d open5gs_5gc iperf3 -s -p "$port"; then
            warn "Failed to start iPerf server on port $port"
        fi
    done
    sleep 3
    
    # Step 3: Start gNBs
    step "[3/6] Starting gNBs"
    save_experiment_state "$tr_num" "$exp_num" "gnb_starting" "$retry_count"
    
    cd ~/
    if ! check_and_free_zmq_ports; then
        error "Failed to prepare ZMQ ports"
        return 1
    fi
    
    if ! retry_with_backoff 2 15 "gNB startup" \
         start_gnb cu_cp_01 1 10.53.1.1 55555 "${exp_dir}/gnb_logs"; then
        error "Failed to start gNB"
        return 1
    fi
    
    # Wait for network bridge
    info "Waiting for Open5GS bridge interface..."
    local bridge_timeout=60
    local bridge_start=$(date +%s)
    local bridge_name=""
    
    while [[ -z "$bridge_name" ]]; do
        local elapsed=$(( $(date +%s) - bridge_start ))
        if (( elapsed >= bridge_timeout )); then
            error "Timeout waiting for Open5GS bridge interface"
            return 1
        fi
        
        bridge_name=$(ip -o addr show | awk '/10\.53\.1\.1/ {print $2; exit}')
        if [[ -n "$bridge_name" ]]; then
            success "Found bridge interface: $bridge_name"
            break
        fi
        sleep 2
    done
    
    # Step 4: Create UE namespaces and start UEs
    step "[4/6] Setting up UEs"
    save_experiment_state "$tr_num" "$exp_num" "ue_setup" "$retry_count"
    
    # Create namespaces
    for i in {1..3}; do
        local ue_ns="ue$i"
        if ! ip netns list | grep -q "^${ue_ns}$"; then
            if sudo ip netns add "$ue_ns"; then
                success "Created namespace: $ue_ns"
            else
                error "Failed to create namespace: $ue_ns"
                return 1
            fi
        else
            info "Namespace $ue_ns already exists"
        fi
    done
    
    # Add routing
    if ! ip route show | grep -q "10.45.0.0/16 via 10.53.1.2"; then
        if sudo ip route add 10.45.0.0/16 via 10.53.1.2; then
            success "Added route to UE network"
        else
            warn "Failed to add route - may already exist"
        fi
    fi
    
    # Start UEs
    for i in {1..3}; do
        if ! retry_with_backoff 2 10 "UE$i startup" \
             start_ue "$i" "${exp_dir}/ue_logs"; then
            error "Failed to start UE$i"
            return 1
        fi
    done
    
    # Step 5: Start GNU Radio scenario
    step "[5/6] Starting GNU Radio scenario"
    save_experiment_state "$tr_num" "$exp_num" "gnuradio_starting" "$retry_count"
    
    info "Launching GNU Radio scenario: $run_scenario_sh"
    if ! bash "$run_scenario_sh"; then
        error "Failed to start GNU Radio scenario"
        return 1
    fi
    
    sleep 5
    
    # Get GNU Radio PID
    if [[ -f /tmp/python_scenario.pid ]]; then
        GNURADIO_PID=$(cat /tmp/python_scenario.pid)
        if [[ -n "$GNURADIO_PID" ]] && kill -0 "$GNURADIO_PID" 2>/dev/null; then
            success "GNU Radio scenario running (PID: $GNURADIO_PID)"
        else
            error "GNU Radio scenario not running properly"
            return 1
        fi
    else
        error "GNU Radio PID file not found"
        return 1
    fi
    
    sleep 5
    
    # Wait for UE connections
    step "Waiting for UE connections"
    for i in {1..3}; do
        if ! wait_for_ue_connection "$i" "${exp_dir}/ue_logs" 120; then
            error "UE$i failed to connect"
            return 1
        fi
    done
    
    # Configure UE routes
    sleep 5
    for i in {1..3}; do
        local ue_ns="ue$i"
        if sudo ip netns exec "$ue_ns" ip link show tun_srsue > /dev/null 2>&1; then
            if sudo ip netns exec "$ue_ns" ip route add default via 10.45.1.1 dev tun_srsue; then
                success "Configured routing for $ue_ns"
            else
                warn "Failed to configure routing for $ue_ns"
            fi
        else
            warn "Interface tun_srsue not found in $ue_ns"
        fi
    done
    
    # Step 6: Start metrics collection and traffic
    step "[6/6] Running experiment"
    save_experiment_state "$tr_num" "$exp_num" "experiment_running" "$retry_count"
    
    cd "${BASE_DIR}/openran/oran-sc-ric"
    
    # Clean up previous metrics files
    rm -f "$metrics_log_file"
    sudo rm -f "$metrics_csv"
    
    # Start metrics collection
    # info "Starting KPM metrics collection"
    # docker compose exec python_xapp_runner ./malicious-detector.py --model_path artifacts_stage1_binary_XGBoost_study.pkl > "$metrics_log_file" 2>&1 &
    # local metrics_pid=$!
    
    # Check for 503 errors in metrics
    # sleep 15
    # if ! check_metrics_503_error "$metrics_log_file"; then
    #     error "Metrics collection failed with 503 error"
    #     kill "$metrics_pid" 2>/dev/null || true
    #     return 1
    # fi
    
    success "Metrics collection is healthy"
    
    # Start traffic generation
    info "Starting traffic generation"
    if ! start_and_wait_for_iperf "$conditions_file" 3 "$exp_dir"; then
        error "Traffic generation failed"
        kill "$metrics_pid" 2>/dev/null || true
        return 1
    fi
    
    # Wait for metrics process to complete
    info "Waiting for metrics collection to complete"
    wait "$metrics_pid" 2>/dev/null || true
    success "Traffic generation completed its active phase."

    info "Stopping traffic and metrics collection..."

    # Stop iPerf traffic first
    for i in {1..3}; do
        local pid_file="/tmp/iperf_UE${i}.pid"
        if [[ -f "$pid_file" ]]; then
            local iperf_pid=$(cat "$pid_file")
            info "Stopping iPerf for UE${i} (PID: $iperf_pid)"
            kill "$iperf_pid" 2>/dev/null || true
            rm -f "$pid_file"
        fi
    done

    # Now, stop the metrics collector
    info "Stopping metrics collector (PID: $metrics_pid)"
    kill "$metrics_pid" 2>/dev/null || true

    # Validate experiment results
    if validate_experiment_completion "$exp_dir" "$tr_num" "$exp_num"; then
        success "Experiment tr${tr_num}/exp${exp_num} completed successfully"
        return 0
    else
        warn "Experiment validation failed"
        return 1
    fi
}

# --- Enhanced Main Loop with Retry Logic ---
main_experiment_loop() {
    for tr_num in $(seq $START_TR $((TOTAL_TRAINING_SETS - 1))); do
        local exp_start=1
        [[ $tr_num -eq $START_TR ]] && exp_start=$START_EXP
        CURRENT_TR=${tr_num}
        for exp_num in $(seq $exp_start $TOTAL_EXPERIMENTS); do
            CURRENT_EXP=${exp_num}
            local retry_key="tr${tr_num}_exp${exp_num}"
            local current_retry=${RETRY_COUNTS[$retry_key]:-0}
            
            ((current_retry++)) || true
            print_main_progress_bar $CURRENT_RUN $TOTAL_RUNS
            
            local experiment_success=false
            
            # Retry loop for individual experiment
            while (( current_retry <= MAX_RETRIES )); do
                info "\n=== Starting Training Set: $tr_num, Experiment: $exp_num ==="
                info "Run: $CURRENT_RUN of $TOTAL_RUNS (Attempt: $((current_retry + 1)))"
                
                if run_single_experiment "$tr_num" "$exp_num" "$current_retry"; then
                    experiment_success=true
                    break
                else
                    ((current_retry++))
                    RETRY_COUNTS[$retry_key]=$current_retry
                    
                    if (( current_retry <= MAX_RETRIES )); then
                        retry_info "Experiment failed, retrying in ${RETRY_DELAY}s (attempt $((current_retry + 1))/$((MAX_RETRIES + 1)))"
                        cleanup
                        sleep $RETRY_DELAY
                    else
                        error "Experiment tr${tr_num}/exp${exp_num} failed after $((MAX_RETRIES + 1)) attempts"
                        break
                    fi
                fi
            done
            
            if [[ "$experiment_success" == "true" ]]; then
                success "✅ Experiment tr${tr_num}/exp${exp_num} completed successfully"
                (( CURRENT_RUN++ ))
                unset RETRY_COUNTS[$retry_key]
            else
                error "❌ Experiment tr${tr_num}/exp${exp_num} permanently failed"
                # Optionally continue with next experiment or exit
                # For now, we'll continue
            fi
            
            # Clean up after each experiment
            cleanup
            
            # Pause between experiments
            if (( current_retry == 0 )); then  # Only pause if no retries were needed
                info "Pausing 10s before next experiment..."
                sleep 10
            fi
            
            # Check if only running specific experiment
            if [[ -n "$ONLY_EXP" ]]; then
                success "✅ Completed requested experiment tr:$tr_num / exp:$ONLY_EXP"
                exit 0
            fi
        done
    done
}

# --- Script Initialization ---
info "🚀 Enhanced Robust Network Experiment Script Starting"
info "Configuration:"
info "  - Training Sets: $START_TR to $((TOTAL_TRAINING_SETS - 1))"
info "  - Experiments per set: $START_EXP to $TOTAL_EXPERIMENTS" 
info "  - Max retries per experiment: $MAX_RETRIES"
info "  - Retry delay: ${RETRY_DELAY}s"
info "  - Total runs: $TOTAL_RUNS"

# Validate required files and directories
if [[ ! -f "$CSV_FILE" ]]; then
    error "UE configuration file not found: $CSV_FILE"
    exit 1
fi

if [[ ! -f "$GNB_CONF" ]]; then
    error "gNB configuration file not found: $GNB_CONF"
    exit 1
fi

if [[ ! -f "$UE_CONF" ]]; then
    error "UE configuration file not found: $UE_CONF"
    exit 1
fi

if [[ ! -d "$BASE_EXP_DIR" ]]; then
    error "Base experiment directory not found: $BASE_EXP_DIR"
    exit 1
fi

success "All required files and directories found"

# Start main experiment loop
main_experiment_loop

info "\n🎉 All experiments completed!"
step "📊 Experiment Summary:"
info "  - Total runs attempted: $CURRENT_RUN"
info "  - Failed experiments: ${#RETRY_COUNTS[@]}"

if (( ${#RETRY_COUNTS[@]} > 0 )); then
    warn "Failed experiments:"
    for key in "${!RETRY_COUNTS[@]}"; do
        warn "  - $key (${RETRY_COUNTS[$key]} retries)"
    done
fi

success "🎉🎉🎉 Enhanced experiment script completed! 🎉🎉🎉"
exit 0
