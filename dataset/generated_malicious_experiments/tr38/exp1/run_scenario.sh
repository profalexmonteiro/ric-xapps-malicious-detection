#!/bin/bash

# Run script for tr38 exp1
# Conditions generated with seed=0.9510722803716607 and p=0.3154541655861943
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 48 --ue2-path-loss-db 17 --ue3-path-loss-db 54 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
