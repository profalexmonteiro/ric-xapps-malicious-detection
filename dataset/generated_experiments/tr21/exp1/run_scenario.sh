#!/bin/bash

# Run script for tr21 exp1
# Conditions generated with seed=0.9767381002905906 and p=0.3575729900399264
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 10 --ue2-path-loss-db 29 --ue3-path-loss-db 49 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
