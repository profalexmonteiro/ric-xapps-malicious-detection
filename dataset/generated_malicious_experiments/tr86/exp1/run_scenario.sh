#!/bin/bash

# Run script for tr86 exp1
# Conditions generated with seed=0.5662547835239691 and p=0.2969831285687733
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 54 --ue2-path-loss-db 8 --ue3-path-loss-db 29 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
