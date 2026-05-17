#!/bin/bash

# Run script for tr19 exp1
# Conditions generated with seed=0.1802513931932832 and p=0.35637536252958535
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 40 --ue2-path-loss-db 30 --ue3-path-loss-db 46 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
