#!/bin/bash

# Run script for tr57 exp1
# Conditions generated with seed=0.5836716216554829 and p=0.4623196709425704
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 6 --ue2-path-loss-db 12 --ue3-path-loss-db 26 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
