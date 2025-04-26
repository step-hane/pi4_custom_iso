#!/bin/bash -e
# Installer X11 minimal
apt-get install -y xserver-xorg xinit xterm

# Créer le script de monitoring
cat << 'EOF' > /home/pi/monitor.sh
#!/bin/bash
TERM=xterm
while true; do
  clear
  echo "=== Audio Analyzer Monitor ==="
  echo "* JACK status:"
  systemctl status jack.service --no-pager
  echo
  echo "* Rust Analyzer (analyzer.service):"
  systemctl status analyzer.service --no-pager
  echo
  echo "* Python TF Server (tfserver.service):"
  systemctl status tfserver.service --no-pager
  echo
  echo "* Network interfaces:"
  ip -brief addr
  echo
  echo "(Actualisé toutes les 5 s)"
  sleep 5
done
EOF
chmod +x /home/${USER_NAME}/monitor.sh
chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/monitor.sh

# Auto-start X11 + monitor
cat << 'EOF' > /home/${USER_NAME}/.xinitrc
#!/bin/bash
# Lancer le script de monitor dans un xterm plein écran
xterm -fullscreen -e /home/${USER_NAME}/monitor.sh
EOF
chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.xinitrc

# Créer service systemd pour démarrer X au login auto
cat << 'EOF' > /etc/systemd/system/autostart-x.service
[Unit]
Description=Auto X11 /home/pi/.xinitrc
After=graphical.target
Wants=graphical.target

[Service]
User=${USER_NAME}
Environment=DISPLAY=:0
ExecStart=/usr/bin/startx
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=graphical.target
EOF

# Activer le service
systemctl enable autostart-x.service
