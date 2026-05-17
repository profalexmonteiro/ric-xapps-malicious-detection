#!/bin/bash

# Run script for tr92 exp1
# Conditions generated with seed=0.7620506037384421 and p=0.445291641797955
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 3 --ue2-path-loss-db 7 --ue3-path-loss-db 16 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
