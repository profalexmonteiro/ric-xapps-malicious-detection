#!/bin/bash

# Run script for tr74 exp1
# Conditions generated with seed=0.6196935902564927 and p=0.41689209449039144
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 50 --ue2-path-loss-db 17 --ue3-path-loss-db 41 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
