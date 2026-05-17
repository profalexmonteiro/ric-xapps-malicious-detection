#!/bin/bash

# Run script for tr30 exp1
# Conditions generated with seed=0.27627055642881115 and p=0.34864815133358795
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 31 --ue2-path-loss-db 44 --ue3-path-loss-db 25 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
