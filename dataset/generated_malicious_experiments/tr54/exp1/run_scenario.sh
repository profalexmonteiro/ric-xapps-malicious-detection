#!/bin/bash

# Run script for tr54 exp1
# Conditions generated with seed=0.5600208794094687 and p=0.48926649357059976
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 13 --ue3-path-loss-db 27 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
