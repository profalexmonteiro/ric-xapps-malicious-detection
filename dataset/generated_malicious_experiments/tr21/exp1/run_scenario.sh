#!/bin/bash

# Run script for tr21 exp1
# Conditions generated with seed=0.6306599238343675 and p=0.4468045646443072
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 57 --ue2-path-loss-db 5 --ue3-path-loss-db 11 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
