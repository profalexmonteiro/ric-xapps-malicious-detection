#!/bin/bash

# Run script for tr32 exp1
# Conditions generated with seed=0.13509739118821906 and p=0.2966533291007429
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 4 --ue2-path-loss-db 14 --ue3-path-loss-db 48 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
