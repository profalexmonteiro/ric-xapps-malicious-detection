#!/bin/bash

# Run script for tr43 exp1
# Conditions generated with seed=0.17537002609416488 and p=0.42088957428181906
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 3 --ue2-path-loss-db 7 --ue3-path-loss-db 17 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
