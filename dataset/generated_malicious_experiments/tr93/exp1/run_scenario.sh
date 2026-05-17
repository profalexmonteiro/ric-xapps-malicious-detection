#!/bin/bash

# Run script for tr93 exp1
# Conditions generated with seed=0.9344236383608178 and p=0.4617029734737713
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 13 --ue2-path-loss-db 29 --ue3-path-loss-db 58 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
