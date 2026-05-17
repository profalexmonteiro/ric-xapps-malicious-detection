#!/bin/bash

# Run script for tr7 exp1
# Conditions generated with seed=0.1816267331572732 and p=0.4878520098184723
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 24 --ue2-path-loss-db 50 --ue3-path-loss-db 20 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
