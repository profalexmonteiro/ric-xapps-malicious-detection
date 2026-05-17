#!/bin/bash

# Run script for tr2 exp1
# Conditions generated with seed=0.7740025384490699 and p=0.3030219510977181
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 9 --ue2-path-loss-db 31 --ue3-path-loss-db 42 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
