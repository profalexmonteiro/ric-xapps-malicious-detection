#!/bin/bash

# Run script for tr20 exp1
# Conditions generated with seed=0.32486538299598233 and p=0.28847312000374836
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 36 --ue2-path-loss-db 33 --ue3-path-loss-db 37 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
