#!/bin/bash -e
# 07-services.sh - Créer et activer les services systemd

# Variables
USER_NAME="pi"

# --- Service JACKD (Jack Audio) ---
cat << EOF > /etc/systemd/system/jackd.service
[Unit]
Description=JACK Audio Daemon
After=multi-user.target

[Service]
User=${USER_NAME}
LimitRTPRIO=infinity
LimitMEMLOCK=infinity
ExecStart=/usr/bin/jackd -dalsa -dhw:USB -r44100 -p256 -n2
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# --- Service Rust Analyzer ---
cat << EOF > /etc/systemd/system/analyzer.service
[Unit]
Description=Rust Audio Analyzer
After=jackd.service

[Service]
User=${USER_NAME}
WorkingDirectory=/home/${USER_NAME}/analyzer
ExecStart=/home/${USER_NAME}/analyzer/target/release/analyzer
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# --- Service Tensorflow Python Server ---
cat << EOF > /etc/systemd/system/tfserver.service
[Unit]
Description=TensorFlow Lite Server
After=network.target

[Service]
User=${USER_NAME}
WorkingDirectory=/home/${USER_NAME}/tflite_models
ExecStart=/usr/bin/python3 /home/${USER_NAME}/tflite_models/server.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# --- Activer les services ---
systemctl enable jackd.service
systemctl enable analyzer.service
systemctl enable tfserver.service
