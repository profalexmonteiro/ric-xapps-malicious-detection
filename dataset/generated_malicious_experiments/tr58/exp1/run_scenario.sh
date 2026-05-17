#!/bin/bash

# Run script for tr58 exp1
# Conditions generated with seed=0.22619032547970122 and p=0.291548677548532
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 18 --ue2-path-loss-db 60 --ue3-path-loss-db 1 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
