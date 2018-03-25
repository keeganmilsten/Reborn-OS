wget --spider www.google.com
if [ "$?" = 0 ]; then
  sudo rm /etc/xdg/autostart/update.desktop
  exec flatpak.sh
else exec /usr/bin/updating.sh
fi
