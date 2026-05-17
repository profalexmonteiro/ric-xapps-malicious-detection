#!/bin/bash

# Run script for tr34 exp1
# Conditions generated with seed=0.024269156253050983 and p=0.4063126959687344
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 12 --ue2-path-loss-db 29 --ue3-path-loss-db 52 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
