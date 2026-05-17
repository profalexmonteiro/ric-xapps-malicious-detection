#!/bin/bash

# Run script for tr18 exp1
# Conditions generated with seed=0.9249309422648205 and p=0.2685604239887035
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 57 --ue2-path-loss-db 5 --ue3-path-loss-db 17 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
