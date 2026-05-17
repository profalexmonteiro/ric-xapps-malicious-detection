#!/bin/bash

# Run script for tr0 exp1
# Conditions generated with seed=0.3732319795868506 and p=0.3454395795475833
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 32 --ue2-path-loss-db 43 --ue3-path-loss-db 27 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
