#!/bin/bash

# Run script for tr72 exp1
# Conditions generated with seed=0.5769483233508865 and p=0.3054314052678345
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 24 --ue2-path-loss-db 52 --ue3-path-loss-db 12 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
