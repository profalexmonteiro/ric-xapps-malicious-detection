#!/bin/bash

# Run script for tr0 exp1
# Conditions generated with seed=0.5517528584151663 and p=0.32628088351494344
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 9 --ue2-path-loss-db 26 --ue3-path-loss-db 50 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
