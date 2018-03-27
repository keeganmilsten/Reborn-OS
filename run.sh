#!/usr/bin/bash
echo "Correcting file permissions"
chmod +x $PWD/Cnchi/postinstall.sh
chmod +x $PWD/Cnchi/10_antergos
chmod +x $PWD/build.sh
chmod +x $PWD/translations.sh
chmod +x $PWD/airootfs/etc/skel/.config/autostart/internet.sh
chmod +x $PWD/airootfs/etc/systemd/scripts/choose-mirror
chmod +x $PWD/airootfs/root/.automated_script.sh
chmod +x $PWD/airootfs/root/customize_airootfs.sh
chmod +x $PWD/airootfs/usr/bin/cnchi-start.sh
chmod +x $PWD/airootfs/usr/bin/internet.sh
echo "DONE"

