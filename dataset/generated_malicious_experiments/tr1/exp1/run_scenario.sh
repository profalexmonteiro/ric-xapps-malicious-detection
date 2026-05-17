#!/bin/bash

# Run script for tr1 exp1
# Conditions generated with seed=0.912740353190805 and p=0.366245692374865
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 42 --ue2-path-loss-db 28 --ue3-path-loss-db 50 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
