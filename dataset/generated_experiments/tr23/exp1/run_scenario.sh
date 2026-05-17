#!/bin/bash

# Run script for tr23 exp1
# Conditions generated with seed=0.664373606398484 and p=0.2625963827253721
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 23 --ue2-path-loss-db 50 --ue3-path-loss-db 13 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
