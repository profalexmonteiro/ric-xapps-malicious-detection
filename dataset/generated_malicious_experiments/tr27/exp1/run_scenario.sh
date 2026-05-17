#!/bin/bash

# Run script for tr27 exp1
# Conditions generated with seed=0.9398368668590198 and p=0.29112546731098754
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 5 --ue2-path-loss-db 16 --ue3-path-loss-db 54 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
