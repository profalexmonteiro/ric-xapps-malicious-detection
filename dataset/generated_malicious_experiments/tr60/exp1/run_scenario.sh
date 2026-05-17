#!/bin/bash

# Run script for tr60 exp1
# Conditions generated with seed=0.48693639426819124 and p=0.44267700618282335
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 35 --ue2-path-loss-db 46 --ue3-path-loss-db 26 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
