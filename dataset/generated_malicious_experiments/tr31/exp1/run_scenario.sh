#!/bin/bash

# Run script for tr31 exp1
# Conditions generated with seed=0.9741445641375719 and p=0.2861816256782335
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 34 --ue2-path-loss-db 36 --ue3-path-loss-db 33 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
