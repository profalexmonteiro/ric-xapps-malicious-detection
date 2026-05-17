#!/bin/bash

# Run script for tr11 exp1
# Conditions generated with seed=0.4988834425525124 and p=0.49068855482967827
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 21 --ue2-path-loss-db 44 --ue3-path-loss-db 32 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
