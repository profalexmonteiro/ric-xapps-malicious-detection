#!/bin/bash

# Run script for tr22 exp1
# Conditions generated with seed=0.6856808557411648 and p=0.27805515343154213
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 41 --ue2-path-loss-db 26 --ue3-path-loss-db 48 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
