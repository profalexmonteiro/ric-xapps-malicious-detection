#!/bin/bash

# Run script for tr23 exp1
# Conditions generated with seed=0.8739656686198097 and p=0.4321894610177268
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 27 --ue2-path-loss-db 58 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
