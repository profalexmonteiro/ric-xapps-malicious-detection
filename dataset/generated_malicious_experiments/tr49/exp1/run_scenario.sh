#!/bin/bash

# Run script for tr49 exp1
# Conditions generated with seed=0.0686186027738754 and p=0.34727106639903815
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 19 --ue2-path-loss-db 55 --ue3-path-loss-db 8 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
