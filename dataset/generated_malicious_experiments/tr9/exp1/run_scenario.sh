#!/bin/bash

# Run script for tr9 exp1
# Conditions generated with seed=0.23413927779265534 and p=0.2727862266843605
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 14 --ue2-path-loss-db 52 --ue3-path-loss-db 10 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
