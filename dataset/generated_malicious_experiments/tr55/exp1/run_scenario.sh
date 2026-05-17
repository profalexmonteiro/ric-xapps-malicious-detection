#!/bin/bash

# Run script for tr55 exp1
# Conditions generated with seed=0.3634240253494485 and p=0.46533792231162513
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 59 --ue2-path-loss-db 2 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
