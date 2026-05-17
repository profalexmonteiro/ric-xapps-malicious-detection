#!/bin/bash

# Run script for tr87 exp1
# Conditions generated with seed=0.30300709112781876 and p=0.43271899742627373
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 35 --ue2-path-loss-db 45 --ue3-path-loss-db 27 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
