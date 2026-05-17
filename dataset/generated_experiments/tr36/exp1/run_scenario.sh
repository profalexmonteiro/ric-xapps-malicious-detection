#!/bin/bash

# Run script for tr36 exp1
# Conditions generated with seed=0.8957174467135006 and p=0.43237310215175395
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 54 --ue2-path-loss-db 11 --ue3-path-loss-db 25 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
