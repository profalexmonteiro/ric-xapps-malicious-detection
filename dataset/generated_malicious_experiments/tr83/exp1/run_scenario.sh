#!/bin/bash

# Run script for tr83 exp1
# Conditions generated with seed=0.7423637333309752 and p=0.49368943048235614
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 39 --ue2-path-loss-db 42 --ue3-path-loss-db 36 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
