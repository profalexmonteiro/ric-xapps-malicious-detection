#!/bin/bash

# Run script for tr35 exp1
# Conditions generated with seed=0.8118088571809292 and p=0.3997037464810942
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 40 --ue2-path-loss-db 33 --ue3-path-loss-db 45 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
