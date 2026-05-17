#!/bin/bash

# Run script for tr28 exp1
# Conditions generated with seed=0.08227339615794653 and p=0.2953632582368171
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 36 --ue2-path-loss-db 35 --ue3-path-loss-db 36 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
