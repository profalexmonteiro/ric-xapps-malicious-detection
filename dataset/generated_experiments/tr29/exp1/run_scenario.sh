#!/bin/bash

# Run script for tr29 exp1
# Conditions generated with seed=0.839368692659577 and p=0.43952491353252854
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 20 --ue2-path-loss-db 46 --ue3-path-loss-db 26 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
