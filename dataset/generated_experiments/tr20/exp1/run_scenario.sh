#!/bin/bash

# Run script for tr20 exp1
# Conditions generated with seed=0.7629129801879145 and p=0.2558403815879264
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 44 --ue2-path-loss-db 21 --ue3-path-loss-db 52 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
