#!/bin/bash

# Run script for tr81 exp1
# Conditions generated with seed=0.35258257339463783 and p=0.2635823035275309
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 16 --ue2-path-loss-db 59 --ue3-path-loss-db 1 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
