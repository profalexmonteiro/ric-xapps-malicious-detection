#!/bin/bash

# Run script for tr14 exp1
# Conditions generated with seed=0.20192264598754872 and p=0.2789837954719381
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 7 --ue2-path-loss-db 23 --ue3-path-loss-db 51 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
