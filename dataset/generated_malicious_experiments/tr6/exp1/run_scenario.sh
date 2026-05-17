#!/bin/bash

# Run script for tr6 exp1
# Conditions generated with seed=0.5425119776726155 and p=0.25446997872023924
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 9 --ue3-path-loss-db 36 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
