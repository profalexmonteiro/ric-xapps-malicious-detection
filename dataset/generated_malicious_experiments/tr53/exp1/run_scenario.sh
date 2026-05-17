#!/bin/bash

# Run script for tr53 exp1
# Conditions generated with seed=0.267611964212527 and p=0.31670356271115047
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 18 --ue2-path-loss-db 58 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
