#!/bin/bash

# Run script for tr95 exp1
# Conditions generated with seed=0.4496053537207701 and p=0.3916810711249468
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 17 --ue2-path-loss-db 43 --ue3-path-loss-db 28 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
