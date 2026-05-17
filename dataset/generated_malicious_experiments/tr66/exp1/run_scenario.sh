#!/bin/bash

# Run script for tr66 exp1
# Conditions generated with seed=0.3183112617664495 and p=0.34570892730240876
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 55 --ue2-path-loss-db 8 --ue3-path-loss-db 23 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
