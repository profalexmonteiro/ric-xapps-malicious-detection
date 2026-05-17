#!/bin/bash

# Run script for tr40 exp1
# Conditions generated with seed=0.06763841935644625 and p=0.2552823814736629
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 21 --ue2-path-loss-db 53 --ue3-path-loss-db 10 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
