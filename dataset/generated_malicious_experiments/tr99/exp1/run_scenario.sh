#!/bin/bash

# Run script for tr99 exp1
# Conditions generated with seed=0.732729171869087 and p=0.271333553477788
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 11 --ue2-path-loss-db 40 --ue3-path-loss-db 27 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
