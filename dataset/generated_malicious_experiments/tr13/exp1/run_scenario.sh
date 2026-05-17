#!/bin/bash

# Run script for tr13 exp1
# Conditions generated with seed=0.9012690327281463 and p=0.44565131130296787
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 43 --ue2-path-loss-db 31 --ue3-path-loss-db 53 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
