#!/bin/bash

# Run script for tr36 exp1
# Conditions generated with seed=0.21268680122385022 and p=0.4527831177328022
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 5 --ue2-path-loss-db 10 --ue3-path-loss-db 23 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
