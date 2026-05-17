#!/bin/bash

# Run script for tr80 exp1
# Conditions generated with seed=0.7112511769136434 and p=0.2568048269962817
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 45 --ue2-path-loss-db 20 --ue3-path-loss-db 53 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
