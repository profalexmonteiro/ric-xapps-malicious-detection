#!/bin/bash

# Run script for tr73 exp1
# Conditions generated with seed=0.9528349790697238 and p=0.35661857064080327
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 19 --ue2-path-loss-db 53 --ue3-path-loss-db 10 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
