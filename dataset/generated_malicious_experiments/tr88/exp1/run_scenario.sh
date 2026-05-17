#!/bin/bash

# Run script for tr88 exp1
# Conditions generated with seed=0.2887237013857148 and p=0.49742147573056594
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 28 --ue2-path-loss-db 57 --ue3-path-loss-db 6 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
