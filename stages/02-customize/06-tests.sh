#!/bin/bash -e
jackd --version || echo "JACK OK"
su - pi -c "cd ~/analyzer && echo 'fn main(){println!(\"Hello RPi\");}' > src/main.rs && cargo run"
python3 - <<PYT
import tensorflow as tf
print("TF version:", tf.__version__)
import tflite_runtime.interpreter as tflite
print("TFLite interpreter OK")
PYT
su - pi -c "startx -- -nocursor & sleep 3 && pgrep monitor.sh && killall Xorg"
