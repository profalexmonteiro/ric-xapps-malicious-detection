#!/bin/bash

# Run script for tr35 exp1
# Conditions generated with seed=0.15442007992628787 and p=0.44626274201200133
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 27 --ue2-path-loss-db 59 --ue3-path-loss-db 2 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
