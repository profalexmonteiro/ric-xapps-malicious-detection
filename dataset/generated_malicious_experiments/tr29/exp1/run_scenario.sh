#!/bin/bash

# Run script for tr29 exp1
# Conditions generated with seed=0.16797892287621188 and p=0.38877348081506136
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 53 --ue2-path-loss-db 12 --ue3-path-loss-db 30 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
