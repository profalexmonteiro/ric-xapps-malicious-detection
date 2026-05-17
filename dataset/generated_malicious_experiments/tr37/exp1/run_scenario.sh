#!/bin/bash

# Run script for tr37 exp1
# Conditions generated with seed=0.7436597913291514 and p=0.38292289249139144
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 58 --ue2-path-loss-db 3 --ue3-path-loss-db 9 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
