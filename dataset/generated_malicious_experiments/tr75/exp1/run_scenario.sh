#!/bin/bash

# Run script for tr75 exp1
# Conditions generated with seed=0.08074099973962592 and p=0.4709226240270177
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 3 --ue2-path-loss-db 6 --ue3-path-loss-db 12 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
