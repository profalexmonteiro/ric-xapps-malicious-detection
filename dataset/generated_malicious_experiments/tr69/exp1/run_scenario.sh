#!/bin/bash

# Run script for tr69 exp1
# Conditions generated with seed=0.36106015999518043 and p=0.3481565501451593
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 57 --ue2-path-loss-db 5 --ue3-path-loss-db 13 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
