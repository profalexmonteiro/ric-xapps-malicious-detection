#!/bin/bash

# Run script for tr63 exp1
# Conditions generated with seed=0.8279409506799017 and p=0.4646761114008001
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 13 --ue3-path-loss-db 28 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
