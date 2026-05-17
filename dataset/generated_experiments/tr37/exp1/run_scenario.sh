#!/bin/bash

# Run script for tr37 exp1
# Conditions generated with seed=0.8075059901439462 and p=0.3830997616289311
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 21 --ue2-path-loss-db 54 --ue3-path-loss-db 10 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
