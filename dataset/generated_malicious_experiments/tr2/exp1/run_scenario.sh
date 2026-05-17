#!/bin/bash

# Run script for tr2 exp1
# Conditions generated with seed=0.8534921096071226 and p=0.29640320969497397
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 10 --ue3-path-loss-db 34 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
