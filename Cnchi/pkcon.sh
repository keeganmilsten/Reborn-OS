wget --spider www.google.com
if [ "$?" = 0 ]; then

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo

pkcon refresh

pkexec rm /usr/share/applications/flatpak.desktop

if [ -f /usr/bin/gnome-software ]; then
gnome-software
echo "STARTING GNOME-SOFTWARE"
fi

if [ -f /usr/bin/plasma-discover ]; then
plasma-discover
echo "STARTING PLASMA-DISCOVER"
fi

else exec /usr/bin/pkcon.sh
fi
