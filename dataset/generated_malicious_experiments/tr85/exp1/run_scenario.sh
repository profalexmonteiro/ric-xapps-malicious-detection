#!/bin/bash

# Run script for tr85 exp1
# Conditions generated with seed=0.6525228867030689 and p=0.39348293234395026
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 39 --ue2-path-loss-db 35 --ue3-path-loss-db 42 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
