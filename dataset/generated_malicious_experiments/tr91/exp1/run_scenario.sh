#!/bin/bash

# Run script for tr91 exp1
# Conditions generated with seed=0.026158949383997473 and p=0.389250016531103
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 49 --ue2-path-loss-db 19 --ue3-path-loss-db 48 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
