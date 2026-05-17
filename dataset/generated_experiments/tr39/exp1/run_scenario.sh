#!/bin/bash

# Run script for tr39 exp1
# Conditions generated with seed=0.6235662702848973 and p=0.40872128925805895
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 28 --ue2-path-loss-db 54 --ue3-path-loss-db 10 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
