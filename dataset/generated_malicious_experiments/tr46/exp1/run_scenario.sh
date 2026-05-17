#!/bin/bash

# Run script for tr46 exp1
# Conditions generated with seed=0.31022537984985016 and p=0.3897907242843134
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 16 --ue2-path-loss-db 41 --ue3-path-loss-db 31 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
