#!/bin/bash

# Run script for tr27 exp1
# Conditions generated with seed=0.9758890107764155 and p=0.32171604501793005
python3 C:\Users\alex_\ric-xapps-malicious-detection\openran\my-srsproject-demo\multi-ue-setup\multi_ue_scenario_nogui.py --ue1-path-loss-db 53 --ue2-path-loss-db 10 --ue3-path-loss-db 31 &
PYTHON_PID=$!
sleep 5
echo "GNURADIO PID: $PYTHON_PID"
echo $PYTHON_PID > /tmp/python_scenario.pid
