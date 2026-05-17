#!/bin/bash

# Run script for tr62 exp1
# Conditions generated with seed=0.8636471816000479 and p=0.45594293025295063
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 50 --ue2-path-loss-db 18 --ue3-path-loss-db 40 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
