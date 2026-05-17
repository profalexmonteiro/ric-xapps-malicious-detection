#!/bin/bash

# Run script for tr48 exp1
# Conditions generated with seed=0.26161038338262066 and p=0.4670636683490306
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 40 --ue2-path-loss-db 37 --ue3-path-loss-db 43 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
