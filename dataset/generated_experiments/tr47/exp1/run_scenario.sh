#!/bin/bash

# Run script for tr47 exp1
# Conditions generated with seed=0.21546258417726774 and p=0.4973154385073092
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 45 --ue2-path-loss-db 29 --ue3-path-loss-db 58 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
