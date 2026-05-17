#!/bin/bash

# Run script for tr16 exp1
# Conditions generated with seed=0.2898453078887906 and p=0.4852438722894479
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 59 --ue2-path-loss-db 2 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
