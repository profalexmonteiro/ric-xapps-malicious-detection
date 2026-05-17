#!/bin/bash

# Run script for tr24 exp1
# Conditions generated with seed=0.13540707003471233 and p=0.38980569767394374
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 44 --ue2-path-loss-db 27 --ue3-path-loss-db 54 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
