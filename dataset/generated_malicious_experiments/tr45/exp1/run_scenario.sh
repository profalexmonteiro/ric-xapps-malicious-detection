#!/bin/bash

# Run script for tr45 exp1
# Conditions generated with seed=0.5626699044297868 and p=0.45678704860862196
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 23 --ue2-path-loss-db 51 --ue3-path-loss-db 16 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
