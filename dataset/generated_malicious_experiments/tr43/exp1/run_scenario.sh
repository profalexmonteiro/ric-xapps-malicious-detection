#!/bin/bash

# Run script for tr43 exp1
# Conditions generated with seed=0.18950269656491447 and p=0.3570197753339512
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 30 --ue2-path-loss-db 47 --ue3-path-loss-db 21 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
