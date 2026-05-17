#!/bin/bash

# Run script for tr15 exp1
# Conditions generated with seed=0.7796886306658942 and p=0.40364748504300285
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 42 --ue2-path-loss-db 30 --ue3-path-loss-db 50 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
