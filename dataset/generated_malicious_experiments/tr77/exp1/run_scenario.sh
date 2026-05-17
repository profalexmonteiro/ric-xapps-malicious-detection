#!/bin/bash

# Run script for tr77 exp1
# Conditions generated with seed=0.1323220397127413 and p=0.25694883024172543
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 35 --ue2-path-loss-db 34 --ue3-path-loss-db 35 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
