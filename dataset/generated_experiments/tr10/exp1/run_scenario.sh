#!/bin/bash

# Run script for tr10 exp1
# Conditions generated with seed=0.8412183272699686 and p=0.4987487546380069
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 34 --ue2-path-loss-db 53 --ue3-path-loss-db 15 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
