#!/bin/bash

# Run script for tr42 exp1
# Conditions generated with seed=0.6908615536558355 and p=0.4062308640954678
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 47 --ue2-path-loss-db 22 --ue3-path-loss-db 53 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
