#!/bin/bash

# Run script for tr4 exp1
# Conditions generated with seed=0.7980481128031772 and p=0.26408712715381655
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 46 --ue2-path-loss-db 19 --ue3-path-loss-db 56 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
