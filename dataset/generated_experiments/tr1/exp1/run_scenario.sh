#!/bin/bash

# Run script for tr1 exp1
# Conditions generated with seed=0.38431784255626716 and p=0.4113859146487022
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 5 --ue2-path-loss-db 12 --ue3-path-loss-db 30 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
