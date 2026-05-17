#!/bin/bash

# Run script for tr40 exp1
# Conditions generated with seed=0.7852470305981125 and p=0.3482047570188446
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 24 --ue2-path-loss-db 55 --ue3-path-loss-db 8 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
