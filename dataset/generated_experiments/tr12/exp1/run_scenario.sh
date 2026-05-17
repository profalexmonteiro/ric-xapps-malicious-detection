#!/bin/bash

# Run script for tr12 exp1
# Conditions generated with seed=0.17839558822578228 and p=0.376385207279719
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 14 --ue2-path-loss-db 37 --ue3-path-loss-db 37 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
