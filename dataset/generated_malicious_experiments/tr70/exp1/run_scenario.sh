#!/bin/bash

# Run script for tr70 exp1
# Conditions generated with seed=0.8752051853685237 and p=0.34126802661570044
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 8 --ue2-path-loss-db 23 --ue3-path-loss-db 56 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
