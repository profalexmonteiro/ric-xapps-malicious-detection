#!/bin/bash

# Run script for tr94 exp1
# Conditions generated with seed=0.8879826226423803 and p=0.39237058109103706
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 28 --ue2-path-loss-db 53 --ue3-path-loss-db 11 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
