#!/bin/bash

# Run script for tr97 exp1
# Conditions generated with seed=0.39867988162860624 and p=0.4864733450727711
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 5 --ue2-path-loss-db 11 --ue3-path-loss-db 23 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
