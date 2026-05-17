#!/bin/bash

# Run script for tr17 exp1
# Conditions generated with seed=0.04776677286734977 and p=0.2627952738496523
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 56 --ue2-path-loss-db 5 --ue3-path-loss-db 20 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
