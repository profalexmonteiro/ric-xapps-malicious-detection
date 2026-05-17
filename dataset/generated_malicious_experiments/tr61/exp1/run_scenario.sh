#!/bin/bash

# Run script for tr61 exp1
# Conditions generated with seed=0.4602879168744265 and p=0.3046226126797236
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 1 --ue2-path-loss-db 2 --ue3-path-loss-db 6 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
