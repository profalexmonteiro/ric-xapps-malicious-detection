#!/bin/bash

# Run script for tr56 exp1
# Conditions generated with seed=0.6523798291516125 and p=0.3479732306377621
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 27 --ue2-path-loss-db 51 --ue3-path-loss-db 14 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
