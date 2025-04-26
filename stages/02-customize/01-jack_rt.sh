#!/bin/bash -e
apt-get update
apt-get install -y jackd2 qjackctl
groupadd -f audio
usermod -aG audio pi
cat <<EOL > /etc/security/limits.d/audio.conf
@audio   -  rtprio     95
@audio   -  memlock    unlimited
EOL
systemctl enable jackdbus
