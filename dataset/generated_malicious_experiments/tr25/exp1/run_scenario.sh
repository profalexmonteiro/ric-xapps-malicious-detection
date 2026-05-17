#!/bin/bash

# Run script for tr25 exp1
# Conditions generated with seed=0.34755008009810523 and p=0.40456446377221056
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 35 --ue2-path-loss-db 41 --ue3-path-loss-db 32 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
