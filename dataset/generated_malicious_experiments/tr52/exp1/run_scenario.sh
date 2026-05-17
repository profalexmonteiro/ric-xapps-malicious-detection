#!/bin/bash

# Run script for tr52 exp1
# Conditions generated with seed=0.09726647643924881 and p=0.29023423351048994
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 20 --ue2-path-loss-db 56 --ue3-path-loss-db 6 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
