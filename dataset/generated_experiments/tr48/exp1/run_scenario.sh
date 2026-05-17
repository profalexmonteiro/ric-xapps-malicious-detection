#!/bin/bash

# Run script for tr48 exp1
# Conditions generated with seed=0.2874083323469692 and p=0.34255342507510805
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 48 --ue2-path-loss-db 18 --ue3-path-loss-db 53 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
