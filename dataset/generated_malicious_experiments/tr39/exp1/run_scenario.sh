#!/bin/bash

# Run script for tr39 exp1
# Conditions generated with seed=0.8499112669468684 and p=0.47940057367931127
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 32 --ue2-path-loss-db 53 --ue3-path-loss-db 13 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
