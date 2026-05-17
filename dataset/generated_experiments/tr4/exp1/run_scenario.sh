#!/bin/bash

# Run script for tr4 exp1
# Conditions generated with seed=0.7794341150489691 and p=0.4655494267997182
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 7 --ue2-path-loss-db 15 --ue3-path-loss-db 33 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
