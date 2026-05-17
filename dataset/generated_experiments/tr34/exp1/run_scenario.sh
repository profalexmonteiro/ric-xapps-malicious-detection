#!/bin/bash

# Run script for tr34 exp1
# Conditions generated with seed=0.7949577946011447 and p=0.3148352633003012
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 21 --ue2-path-loss-db 57 --ue3-path-loss-db 5 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
