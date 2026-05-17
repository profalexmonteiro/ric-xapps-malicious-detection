#!/bin/bash

# Run script for tr28 exp1
# Conditions generated with seed=0.6089941085744891 and p=0.3041053247552984
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 9 --ue3-path-loss-db 31 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
