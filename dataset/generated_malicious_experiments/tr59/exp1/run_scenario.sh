#!/bin/bash

# Run script for tr59 exp1
# Conditions generated with seed=0.7526421901878879 and p=0.4978650371873677
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario.py --ue1-path-loss-db 29 --ue2-path-loss-db 59 --ue3-path-loss-db 3 &
PYTHON_PID=$!
echo $PYTHON_PID > /tmp/python_scenario.pid
