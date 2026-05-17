#!/bin/bash

# Run script for tr8 exp1
# Conditions generated with seed=0.6303601239319068 and p=0.3748510414019156
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 42 --ue2-path-loss-db 29 --ue3-path-loss-db 49 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
