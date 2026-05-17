#!/bin/bash

# Run script for tr50 exp1
# Conditions generated with seed=0.24743506509411664 and p=0.41063756382911176
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 4 --ue2-path-loss-db 10 --ue3-path-loss-db 26 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
