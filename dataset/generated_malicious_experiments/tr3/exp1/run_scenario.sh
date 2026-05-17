#!/bin/bash

# Run script for tr3 exp1
# Conditions generated with seed=0.779071956456913 and p=0.3714134236931699
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 22 --ue2-path-loss-db 58 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
