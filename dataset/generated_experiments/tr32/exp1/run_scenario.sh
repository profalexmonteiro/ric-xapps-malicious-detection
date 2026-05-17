#!/bin/bash

# Run script for tr32 exp1
# Conditions generated with seed=0.27752719754493843 and p=0.27947732372892736
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 30 --ue2-path-loss-db 42 --ue3-path-loss-db 25 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
