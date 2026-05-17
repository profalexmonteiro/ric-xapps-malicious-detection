#!/bin/bash

# Run script for tr31 exp1
# Conditions generated with seed=0.20788611274997745 and p=0.2846374747406565
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 54 --ue2-path-loss-db 9 --ue3-path-loss-db 32 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
