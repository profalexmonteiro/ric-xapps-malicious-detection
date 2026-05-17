#!/bin/bash

# Run script for tr41 exp1
# Conditions generated with seed=0.048376657676801556 and p=0.27602451699932207
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 51 --ue2-path-loss-db 12 --ue3-path-loss-db 44 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
