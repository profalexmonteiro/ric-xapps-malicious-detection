#!/bin/bash

# Run script for tr65 exp1
# Conditions generated with seed=0.40688416412679507 and p=0.3824245487648904
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 36 --ue2-path-loss-db 39 --ue3-path-loss-db 33 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
