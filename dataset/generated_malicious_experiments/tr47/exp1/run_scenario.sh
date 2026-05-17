#!/bin/bash

# Run script for tr47 exp1
# Conditions generated with seed=0.224481433763245 and p=0.43638542967748906
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 25 --ue2-path-loss-db 58 --ue3-path-loss-db 4 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
