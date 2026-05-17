#!/bin/bash

# Run script for tr33 exp1
# Conditions generated with seed=0.7075444616524403 and p=0.4617284245193092
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 19 --ue2-path-loss-db 41 --ue3-path-loss-db 36 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
