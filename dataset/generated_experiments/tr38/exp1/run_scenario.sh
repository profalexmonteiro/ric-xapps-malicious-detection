#!/bin/bash

# Run script for tr38 exp1
# Conditions generated with seed=0.33850460535131216 and p=0.3513065502477747
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 16 --ue2-path-loss-db 45 --ue3-path-loss-db 23 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
