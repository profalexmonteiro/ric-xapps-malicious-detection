#!/bin/bash

# Run script for tr64 exp1
# Conditions generated with seed=0.32641081423162205 and p=0.49732041472923294
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 19 --ue2-path-loss-db 39 --ue3-path-loss-db 42 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
