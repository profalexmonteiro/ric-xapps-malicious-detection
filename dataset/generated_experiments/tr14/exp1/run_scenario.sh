#!/bin/bash

# Run script for tr14 exp1
# Conditions generated with seed=0.6682332627806536 and p=0.2756734438027578
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 38 --ue2-path-loss-db 31 --ue3-path-loss-db 40 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
