#!/bin/bash

# Run script for tr6 exp1
# Conditions generated with seed=0.95645260293161 and p=0.4092725997194753
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 10 --ue2-path-loss-db 25 --ue3-path-loss-db 58 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
