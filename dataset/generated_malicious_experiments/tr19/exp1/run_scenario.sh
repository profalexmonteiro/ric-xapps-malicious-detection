#!/bin/bash

# Run script for tr19 exp1
# Conditions generated with seed=0.42241608683188653 and p=0.39441969783419534
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 30 --ue2-path-loss-db 49 --ue3-path-loss-db 18 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
