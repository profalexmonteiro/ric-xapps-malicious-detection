#!/bin/bash

# Run script for tr79 exp1
# Conditions generated with seed=0.8346196903935318 and p=0.3398706932236899
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 36 --ue2-path-loss-db 36 --ue3-path-loss-db 36 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
