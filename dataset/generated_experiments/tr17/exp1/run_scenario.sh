#!/bin/bash

# Run script for tr17 exp1
# Conditions generated with seed=0.02380696342939813 and p=0.31283801233293884
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 24 --ue2-path-loss-db 52 --ue3-path-loss-db 11 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
