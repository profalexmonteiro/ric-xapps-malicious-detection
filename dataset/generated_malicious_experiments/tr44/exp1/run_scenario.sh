#!/bin/bash

# Run script for tr44 exp1
# Conditions generated with seed=0.5348070873623079 and p=0.35655267757596665
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 18 --ue2-path-loss-db 50 --ue3-path-loss-db 15 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
