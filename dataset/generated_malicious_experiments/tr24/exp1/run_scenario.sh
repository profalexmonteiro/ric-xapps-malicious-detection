#!/bin/bash

# Run script for tr24 exp1
# Conditions generated with seed=0.6306007433674706 and p=0.38729985550562307
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 51 --ue2-path-loss-db 15 --ue3-path-loss-db 40 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
