#!/bin/bash

# Run script for tr33 exp1
# Conditions generated with seed=0.6992809196535112 and p=0.37284283370390847
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 1 --ue2-path-loss-db 3 --ue3-path-loss-db 8 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
