#!/bin/bash

# Run script for tr98 exp1
# Conditions generated with seed=0.8845090502560095 and p=0.2888802674130598
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 21 --ue2-path-loss-db 55 --ue3-path-loss-db 8 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
