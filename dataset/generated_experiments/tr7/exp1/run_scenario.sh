#!/bin/bash

# Run script for tr7 exp1
# Conditions generated with seed=0.5060011604200807 and p=0.28632739592040846
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 23 --ue2-path-loss-db 52 --ue3-path-loss-db 11 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
