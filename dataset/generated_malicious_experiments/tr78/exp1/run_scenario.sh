#!/bin/bash

# Run script for tr78 exp1
# Conditions generated with seed=0.5504302622006818 and p=0.374598944123514
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 1 --ue2-path-loss-db 3 --ue3-path-loss-db 9 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
