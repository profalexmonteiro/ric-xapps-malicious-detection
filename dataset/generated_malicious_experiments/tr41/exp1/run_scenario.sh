#!/bin/bash

# Run script for tr41 exp1
# Conditions generated with seed=0.10004160168596014 and p=0.4855827128531549
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 34 --ue2-path-loss-db 51 --ue3-path-loss-db 17 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
