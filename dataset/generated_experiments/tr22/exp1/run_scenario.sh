#!/bin/bash

# Run script for tr22 exp1
# Conditions generated with seed=0.8828198361327002 and p=0.31859893882470486
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 27 --ue2-path-loss-db 49 --ue3-path-loss-db 16 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
