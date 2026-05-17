#!/bin/bash

# Run script for tr16 exp1
# Conditions generated with seed=0.6897897599441989 and p=0.39836030192745153
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 25 --ue2-path-loss-db 58 --ue3-path-loss-db 3 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
