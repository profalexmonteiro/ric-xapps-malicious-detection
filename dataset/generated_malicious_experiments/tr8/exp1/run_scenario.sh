#!/bin/bash

# Run script for tr8 exp1
# Conditions generated with seed=0.3662797679076394 and p=0.2988951501248063
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 2 --ue2-path-loss-db 7 --ue3-path-loss-db 25 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
