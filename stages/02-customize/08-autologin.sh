#!/bin/bash -e
# Forcer l'autologin en console + démarrage direct de startx

# Modifier getty pour login automatique sur tty1
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat << 'EOT' > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I \$TERM
EOT

# Activer le mode graphique par défaut
systemctl set-default graphical.target
