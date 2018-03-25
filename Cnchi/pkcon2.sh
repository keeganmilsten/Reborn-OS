wget --spider www.google.com
if [ "$?" = 0 ]; then

pkexec rm /etc/xdg/autostart/update.desktop

killall -9 yad

else exec /usr/bin/pkcon2.sh
fi
