#!/bin/bash

# Run script for tr5 exp1
# Conditions generated with seed=0.066170914048021 and p=0.25610263738859745
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 56 --ue2-path-loss-db 5 --ue3-path-loss-db 20 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
