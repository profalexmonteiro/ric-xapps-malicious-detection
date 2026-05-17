#!/bin/bash

# Run script for tr82 exp1
# Conditions generated with seed=0.7799270948080193 and p=0.26881555177025546
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 58 --ue2-path-loss-db 2 --ue3-path-loss-db 9 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
