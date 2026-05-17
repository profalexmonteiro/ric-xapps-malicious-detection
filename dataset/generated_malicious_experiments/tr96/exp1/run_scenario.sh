#!/bin/bash

# Run script for tr96 exp1
# Conditions generated with seed=0.07903304700610642 and p=0.4080055469080206
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 39 --ue2-path-loss-db 36 --ue3-path-loss-db 41 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
