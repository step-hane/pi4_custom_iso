#!/bin/bash -e
# Installer le support Python OSC et configurer un serveur OSC

apt-get update
apt-get install -y python3-pip

pip3 install --upgrade pip
pip3 install python-osc

# Créer le serveur OSC
cat << 'EOPY' > /home/${USER_NAME}/osc_server.py
from pythonosc import dispatcher
from pythonosc import osc_server

def print_handler(address, *args):
    print(f"Received {address}: {args}")

dispatcher = dispatcher.Dispatcher()
dispatcher.map("/audio", print_handler)

server = osc_server.ThreadingOSCUDPServer(("0.0.0.0", 8000), dispatcher)
print("Serving on {}".format(server.server_address))
server.serve_forever()
EOPY

chmod +x /home/${USER_NAME}/osc_server.py
chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/osc_server.py

# Créer le service systemd
cat << 'EOS' > /etc/systemd/system/oscserver.service
[Unit]
Description=Python OSC Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/${USER_NAME}/osc_server.py
WorkingDirectory=/home/${USER_NAME}/
StandardOutput=journal
StandardError=journal
Restart=always
User=${USER_NAME}

[Install]
WantedBy=multi-user.target
EOS

systemctl enable oscserver.service
