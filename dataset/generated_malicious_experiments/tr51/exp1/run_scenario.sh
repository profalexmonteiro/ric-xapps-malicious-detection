#!/bin/bash

# Run script for tr51 exp1
# Conditions generated with seed=0.07974055668078728 and p=0.476544564425861
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 27 --ue2-path-loss-db 57 --ue3-path-loss-db 5 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
