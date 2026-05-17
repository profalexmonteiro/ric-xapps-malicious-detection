#!/bin/bash

# Run script for tr84 exp1
# Conditions generated with seed=0.8365051134355587 and p=0.3116040850105739
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 3 --ue2-path-loss-db 9 --ue3-path-loss-db 30 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
