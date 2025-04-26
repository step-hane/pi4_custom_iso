#!/bin/bash -e
apt-get install -y xserver-xorg xinit xterm
cat << 'EOMON' > /home/pi/monitor.sh
#!/bin/bash
while true; do
  clear
  echo "=== Audio Analyzer Monitor ==="
  echo "* JACK status:" && systemctl status jackdbus --no-pager
  echo "* Rust Analyzer (analyzer.service):" && systemctl status analyzer --no-pager
  echo "* Python TF Server (tfserver.service):" && systemctl status tfserver --no-pager
  echo "* Network interfaces:" && ip -brief addr
  echo "(Actualisé toutes les 5 s)"
  sleep 5
done
EOMON
chmod +x /home/pi/monitor.sh && chown pi:pi /home/pi/monitor.sh
cat << 'EXSRV' > /home/pi/.xinitrc
#!/bin/bash
xterm -fullscreen -e /home/pi/monitor.sh
EXSRV
chown pi:pi /home/pi/.xinitrc
cat << 'ESYSD' > /etc/systemd/system/autostart-x.service
[Unit]
Description=Auto X11 /home/pi/.xinitrc
After=graphical.target
Wants=graphical.target

[Service]
User=pi
Environment=DISPLAY=:0
ExecStart=/usr/bin/startx
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=graphical.target
ESYSD
systemctl enable autostart-x.service
