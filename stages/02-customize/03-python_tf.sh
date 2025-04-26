#!/bin/bash -e
apt-get update
apt-get install -y python3-pip python3-venv
pip3 install --upgrade pip
pip3 install numpy tensorflow tflite-runtime scikit-learn matplotlib
mkdir -p /home/pi/tflite_models
chown pi:pi /home/pi/tflite_models
