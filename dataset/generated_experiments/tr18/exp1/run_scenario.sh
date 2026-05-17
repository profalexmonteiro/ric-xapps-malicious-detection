#!/bin/bash

# Run script for tr18 exp1
# Conditions generated with seed=0.1860189115079394 and p=0.45952009731730536
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 18 --ue2-path-loss-db 39 --ue3-path-loss-db 39 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
