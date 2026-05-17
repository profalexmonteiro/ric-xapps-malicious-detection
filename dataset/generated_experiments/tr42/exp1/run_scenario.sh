#!/bin/bash

# Run script for tr42 exp1
# Conditions generated with seed=0.5330383136062866 and p=0.28406108184137435
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 46 --ue2-path-loss-db 20 --ue3-path-loss-db 56 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
