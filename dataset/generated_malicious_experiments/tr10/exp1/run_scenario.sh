#!/bin/bash

# Run script for tr10 exp1
# Conditions generated with seed=0.8057260735228386 and p=0.46304290056321684
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 9 --ue2-path-loss-db 20 --ue3-path-loss-db 44 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
