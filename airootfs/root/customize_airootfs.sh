
#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl set-default graphical.target
systemctl -fq enable pacman-init.service

# EXPERIMENTAL

# Enable Services

        if [ -f "/etc/systemd/system/livecd.service" ]; then
            systemctl -fq enable livecd
        fi
        systemctl -fq enable systemd-networkd
        if [ -f "/usr/lib/systemd/system/NetworkManager.service" ]; then
            systemctl -fq enable NetworkManager NetworkManager-wait-online
        fi
        if [ -f "/etc/systemd/system/livecd-alsa-unmuter.service" ]; then
            systemctl -fq enable livecd-alsa-unmuter
        fi
        if [ -f "/etc/systemd/system/vboxservice.service" ]; then
            systemctl -fq enable vboxservice
        fi
        systemctl -fq enable ModemManager
        systemctl -fq enable upower

        systemctl -fq enable sddm
        chmod +x /etc/lightdm/Xsession
       
        # Disable pamac if present
        if [ -f "/usr/lib/systemd/system/pamac.service" ]; then
            systemctl -fq disable pamac pamac-cleancache.timer pamac-mirrorlist.timer
        fi
        # Enable systemd-timesyncd (ntp)
	systemctl -fq enable systemd-timesyncd
	
	#Enable Repository Configuration
	systemctl -fq enable internet.service

dkms autoinstall

# Enable lightdm by disabling root login
        echo "Adding autologin group"
        groupadd -r autologin
        echo "Adding nopasswdlogin group"
        groupadd -r nopasswdlogin
        echo "Adding Reborn OS user"
        useradd -m -g users -G "audio,disk,optical,wheel,network,autologin,nopasswdlogin" reborn
        # Set Reborn account passwordless
        passwd -d reborn
	chown -R reborn:users /home/reborn
	echo "DONE FIXING ROOT LOGIN"

#Various fixes
        if [ -f /usr/bin/update-ca-trust ]; then
            /usr/bin/update-ca-trust
        fi
        if [ -f /usr/bin/update-desktop-database ]; then
            /usr/bin/update-desktop-database --quiet
        fi
        if [ -f /usr/bin/update-mime-database ]; then
            /usr/bin/update-mime-database /usr/share/mime
        fi
        if [ -f /usr/bin/gdk-pixbuf-query-loaders ]; then
            /usr/bin/gdk-pixbuf-query-loaders --update-cache
        fi

# Fix sudoers
        chown -R root:root /etc/
        chmod 660 /etc/sudoers

