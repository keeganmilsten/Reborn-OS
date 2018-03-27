gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout '0' && gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout '0'
wget --spider www.google.com
if [ "$?" = 0 ]; then
  sudo pacman -Syy
  sudo pacman-key --init
  sudo pacman-key --populate archlinux antergos aurarchlinux
  sudo pacman-key --refresh-keys
  sudo pacman -Syy
  reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
if [ ! -z $(grep "eu" "etc/pacman.d/mirrorlist") ]; then 
  sudo cp /usr/bin/cnchi/pacman.conf /etc/
  sudo mv /usr/bin/cnchi/pacman2.tmpl /usr/bin/cnchi/data/pacman.tmpl
fi
else exec /home/$USER/.config/autostart/internet.sh
fi


