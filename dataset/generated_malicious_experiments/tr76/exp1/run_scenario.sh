#!/bin/bash

# Run script for tr76 exp1
# Conditions generated with seed=0.3220066122538442 and p=0.41359798311744933
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 55 --ue2-path-loss-db 9 --ue3-path-loss-db 22 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
