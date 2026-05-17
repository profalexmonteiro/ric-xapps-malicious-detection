#!/bin/bash

# Run script for tr68 exp1
# Conditions generated with seed=0.9750878913336771 and p=0.44137206925053807
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 23 --ue2-path-loss-db 51 --ue3-path-loss-db 16 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
