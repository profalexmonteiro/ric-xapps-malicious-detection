#!/bin/bash

# Run script for tr67 exp1
# Conditions generated with seed=0.7794812500554666 and p=0.2887374454790007
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 40 --ue2-path-loss-db 29 --ue3-path-loss-db 44 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
