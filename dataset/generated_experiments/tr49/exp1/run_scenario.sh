#!/bin/bash

# Run script for tr49 exp1
# Conditions generated with seed=0.39753863139239903 and p=0.346079962065335
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 47 --ue2-path-loss-db 19 --ue3-path-loss-db 56 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
