#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  features_info.py
#
#  Copyright © 2013-2016 Antergos
#
#  This file is part of Cnchi.
#
#  Cnchi is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  Cnchi is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  The following additional terms are in effect as per Section 7 of the license:
#
#  The preservation of all legal notices and author attributions in
#  the material or in the Appropriate Legal Notices displayed
#  by works containing it is required.
#
#  You should have received a copy of the GNU General Public License
#  along with Cnchi; If not, see <http://www.gnu.org/licenses/>.


""" Features information """

# Note: As each desktop has its own features, these are listed
# in desktop_info file instead of here.


ICON_NAMES = {
    'a11y': 'preferences-desktop-accessibility',
    'aur': 'system-software-install',
    'bluetooth': 'bluetooth',
    'cups': 'printer',
    'chromium': 'chromium',
    'dropbox': 'dropbox',
    'email': 'thunderbird',
    'firefox': 'firefox',
    'firewall': 'network-server',
    'flash': 'flash',
    'fonts': 'preferences-desktop-font',
    'firewire': 'drive-harddisk-ieee1394',
    'games': 'applications-games',
#    'graphics': 'apps.com.pixlr',
    'graphics': 'accessories-painting',
    'gtk-play': 'applications-games',
    'hardinfo': 'hardinfo',
    'qt-play': 'applications-games',
    'maintenance': 'baobab',
    'movie': 'artemanufrij.screencast',
    'graphic_drivers': 'gnome-system',
    'lamp': 'applications-internet',
    'lts': 'applications-accessories',
    'nemo': 'system-file-manager',
    'nautilus': 'system-file-manager',
    'nixnote': 'evernote',
    'office': 'libreoffice-writer',
    'power': 'battery-full-charged',
    'sshd': 'gnome-mime-x-directory-smb-share',
    'spotify': 'spotify-client',
#    'skype': 'skype',
    'visual': 'video-display',
    'vivaldi': 'vivaldi',
    'vlc': 'vlc',
    'wallpapers': 'background',
    'wine': 'wine',
    'opera': 'opera'}


# See http://docs.python.org/2/library/gettext.html "22.1.3.4. Deferred translations"
def _(message):
    return message

TITLES = {
    'a11y': _("Adds accessibility packages"),
    'aur': _("Arch User Repository (AUR) Support"),
    'bluetooth': _("Bluetooth Support"),
    'cups': _("Printing Support"),
    'chromium': _("Chromium Web Browser"),
    'dropbox': _("Dropbox"),
    'email': _("Desktop Email Client"),
    'firefox': _("Firefox Web Browser"),
    'opera':_("Opera Web Browser"),
    'vivaldi': _("Vivaldi Web Browser"),
    'firewall': _("Uncomplicated Firewall"),
    'flash': _("Flash plugins"),
    'fonts': _("Extra Truetype Fonts"),
    'firewire': _("Support For Firewire Devices"),
    'games': _("Steam + PlayonLinux"),
    'gtk-play': _("Popular Games for Linux"),
    'qt-play': _("Popular Games for Linux"),
    'hardinfo': _("Hardware Analysis"),
    'maintenance': _("Applications to Perform System Maintenance"),
    'movie': _("Common Video Editing Programs for Linux"),
    'graphics': _("Common Photo editing Programs for Linux"),
    'graphic_drivers': _("Graphic drivers (Proprietary)"),
    'lamp': _("Apache (or Nginx) + Mariadb + PHP"),
    'lts': _("Kernel (LTS version)"),
    'office': _("LibreOffice"),
    'power': _("Power Saving"),
    'sshd': _("Windows sharing SMB"),
#    'skype': _("Skype"),
    'spotify': _("Spotify"),
    'visual': _("Visual Effects"),
    'vlc': _("VLC"),
    'wallpapers': _("Wallpapers Cycler"),
    'wine': _("Run Windows Programs on Linux"),
    'nemo': _("Nemo File Manager"),
    'nixnote': _("Evernote For Linux"),
    'nautilus': _("Nautilus File Manager")}

DESCRIPTIONS = {
    'a11y': _("Useful packages for individuals who are blind or visually impaired."),
    'aur': _("The AUR is a community-driven repository for Arch users."),
    'bluetooth': _("Enables your system to make wireless connections via Bluetooth."),
    'chromium': _("Open-source web browser from Google."),
    'email': _("Installs Thunderbird as your Desktop Email Client"),
    'dropbox': _("Free file hosting service for Linux"),
    'firefox': _("A popular open-source graphical web browser from Mozilla."),
    'opera':_("Opera is an innovative, minimalistic web browser from Opera.Inc"),
    'vivaldi': _("Vivaldi is a free, fast web browser designed for power-users."),
    'flash': _("Freeware software normally used for multimedia."),
    'fonts': _("TrueType fonts from the Google Fonts project."),
    'firewire': _("Linux Support For Firewire Devices"),
    'graphic_drivers': _("Installs AMD or Nvidia proprietary graphic driver."),
    'games': _("Installs Steam and Playonlinux for gaming enthusiasts."),
    'gtk-play': _("Popular games for Linux, all created for use on your Desktop Environment"),
    'hardinfo': _("Easy application for extensive hardware analysis"),
    'qt-play': _("Popular games for Linux, all created for use on your Desktop Environment"),
    'maintenance': _("Common Applications to Perform System Maintenance On Linux"),
    'movie': _("Common video editing programs for Linux"),
    'graphics': _("Common Photo editing Programs for Linux"),
    'lamp': _("Apache (or Nginx) + Mariadb + PHP installation and setup."),
    'cups': _("Installation of printer drivers and management tools."),
    'office': _("Open source office suite. Supports editing MS Office files."),
    'visual': _("Enable transparency, shadows, and other desktop effects."),
    'vlc': _("Ultimate Media Player For Linux"),
    'firewall': _("Control the incoming and outgoing network traffic."),
    'lts': _("Long term support (LTS) Linux kernel and modules."),
    'power': _("Power Saving Tools Geared Specifically for Laptops"),
    'sshd': _("Provides client access to shared files and printers."),
 #   'skype': _("A User Friendly Video Chat Tool Made By Microsoft"),
    'spotify': _("A widely popular music, podcast, and video streaming service"),
    'nemo': _("Default file manager for the Cinnamon desktop."),
    'wallpapers': _("Wallpapers Cycler That Changes Wallpapers Every Day"),
    'wine': _("Run Common Windows Programs on Linux Easily"),
    'nixnote': _("An Opensource implementation of Evernote for Linux"),
    'nautilus': _("Default file manager for the Gnome desktop.")}

TOOLTIPS = {
    'a11y': _("Useful packages for individuals who are blind or visually impaired."),
    'aur': _("Use yaourt to install AUR packages.\n"
             "The AUR was created to organize and share new packages\n"
             "from the community and to help expedite popular packages'\n"
             "inclusion into the [community] repository."),
    'bluetooth': _("Bluetooth is a standard for the short-range wireless\n"
                   "interconnection of cellular phones, computers, and\n"
                   "other electronic devices. In Linux, the canonical\n"
                   "implementation of the Bluetooth protocol stack is BlueZ."),
    'cups': _("CUPS is the standards-based, open source printing\n"
              "system developed by Apple Inc. for OS® X and other\n"
              "UNIX®-like operating systems."),
    'chromium': _("Chromium is an open-source browser project that aims to build a\n"
                  "safer, faster, and more stable way for all users to experience the web.\n"
                  "(this is the default)"),
    'email': _("Thunderbird is one of the most common and stable desktop email clients\n"
               "for Linux around. It is is a free, open source, cross-platform email, news,\n"
               "RSS, and chat client developed by the Mozilla Foundation for you."),
    'dropbox': _("Dropbox is a free file hosting and synchronization service for Linux\n"
                 "that integrates fully into your file manager - all for free"),
    'firefox': _("Mozilla Firefox (known simply as Firefox) is a free and\n"
                 "open-source web browser developed for Windows, OS X, and Linux,\n"
                 "with a mobile version for Android, by the Mozilla Foundation and\n"
                 "its subsidiary, the Mozilla Corporation. Firefox uses the Gecko\n"
                 "layout engine to render web pages, which implements current and\n"
                 "anticipated web standards.  Enable this option to install Firefox\n"
                 "instead of Chromium"),
    'opera':_("Opera is a freeware, cross-platform web browser developed by\n"
              "Opera.Inc. The browser is aimed at conventional internet users\n"
              "and those who enjoy simplicity"),
    'vivaldi': _("Vivaldi is a freeware, cross-platform web browser developed by\n"
                 "Vivaldi Technologies. It was officially launched on April 12, 2016.\n"
                 "The browser is aimed at staunch technologists, heavy Internet users,\n"
                 "and previous Opera web browser users disgruntled by Opera's transition\n"
                 "from the Presto layout engine to the Blink layout engine, which\n"
                 "removed many popular features."),
    'firewall': _("Ufw stands for Uncomplicated Firewall, and is a program for\n"
                  "managing a netfilter firewall. It provides a command line\n"
                  "interface and aims to be uncomplicated and easy to use."),
    'flash': _("Adobe Flash Player is freeware software for using content created\n"
               "on the Adobe Flash platform, including viewing multimedia, executing\n"
               "rich internet applications and streaming video and audio."),
    'fonts': _("Fonts: adobe-source-code-pro, adobe-source-sans-pro, jsmath, lohit\n"
               "oldstand, openarch, otf-bitter, otf-goudy, andika, anonymous-pro\n"
               "cantarell, cardo, chromeos-fonts, comfortaa, droid, google-fonts\n"
               "google-webfonts, inconsolata, kimberly_geswein_print, lekton\n"
               "medievalsharp, nova, oldstandard, opensans, oxygen, pt-mono\n"
               "pt-sans, roboto, sil-fonts, sortsmillgoudy, source-code-pro\n"
               "source-sans-pro, ubuntu-font-family, vollkorn, fira-mono\n"
               "fira-sans and lato."),
    'firewire': _("NOTE: IF YOU ARE UNSURE EXACTLY OF WHAT FIREWIRE IS, IT IS ADVISED TO\n"
                  "NOT ENABLE THIS FEATURE.\n"
                  "That said, firewire is an alternative introduced by Apple to USB devices\n"
                  "that offers a much faster data exchange rate. It is often used in cameras\n"
                  "and other small devices."),
    'games': _("Steam is one of the most popular gaming clients that supports\n"
               "linux in technology and gaming, while PlayOnLinux\n"
               "is a very easy manager to setting up games to play\n"
               "through wine, instead of doing it manually."),
    'gtk-play': _("Popular games for Linux, ranging from complex games like 0 A.D,\n"
                  "Battle for Wesnoth, and Super Tux to basics like Solitaire,\n"
                  "Mines, and Soduku - all tailored for a gtk environemt"),
    'hardinfo': _("Simple application for hardware analysis and system benchmarking.\n"
                  "Through this, you can easily view all of your system specs without\n"
                  "having to revert to the commandline."),
    'qt-play': _("Popular games for Linux, ranging from complex games like 0 A.D,\n"
                 "Battle for Wesnoth, and Super Tux to basics like Solitaire,\n"
                 "Mines, and Soduku - all tailored for a qt environemt"),
    'maintenance': _("This option install some common applications used for\n"
                     "system maintenance in Linux.\n"
                     "Specificaly, this option installs Bleachbit, Stacer, Timeshift, and Reborn Recovery.\n"
                     "BleachBit is a free and open-source disk space cleaner, privacy manager,\n"
                     "and computer system optimizer. Whereas Bleachbit and Stacer both primarily clean your system,\n"
                     "Timeshift and Reborn Recovery are preventative solutions to sudden losses\n"
                     "of data. Timeshift enables you to easily backup your data locally\n"
                     "while Reborn Recovery allows you to save a list of all your installed\n"
                     "programs in a file so that you can reinstall them later."),
    'movie': _("Common video editing programs for Linux, such as Open Shot, KdenLive,\n"
               "Pitivi, Cinelerra, and Avidemux"),
    'graphics': _("Common Photo editing Programs for Linux, such as Gimp, GtThumb,\n"
                  "Rapid Photo Downloader, Rawtherapee, and DarkTable"),
    'graphic_drivers': _("Installs AMD or Nvidia proprietary graphics driver instead\n"
                         "of the open-source variant. Do NOT install this if you have a\n"
                         "Nvidia Optimus laptop"),
    'lamp': _("This option installs a web server (you can choose\n"
              "Apache or Nginx) plus a database server (Mariadb)\n"
              "and PHP."),
    'lts': _("The linux-lts package is an alternative Arch kernel package.\n"
             "This particular kernel version enjoys long-term support from upstream,\n"
             "including security fixes and some feature backports. Additionally, this\n"
             "package includes ext4 support. For Antergos users seeking a long-term\n"
             "support kernel, or who want a fallback kernel in case the latest kernel\n"
             "version causes problems, this option is the answer."),
    'office': _("LibreOffice is the free power-packed Open Source\n"
                "personal productivity suite for Windows, Macintosh\n"
                "and Linux, that gives you six feature-rich applications\n"
                "for all your document production and data processing\n"
                "needs: Writer, Calc, Impress, Draw, Math and Base."),
    'power': _("Two programs are installed through this, namely TLP and Thermald.\n"
               "TLP will automatically adjust your laptop to optimize your battery\n"
               "performance in the background without interfering with your daily use at all,\n"
               "and Thermald will conveniently ensure that your fans and CPU both remain\n"
               "at acceptable levels"),
    'sshd': _("Most usage of SMB involves computers running Microsoft Windows.\n"
             "Use this option to be able to browse SMB shares from your computer."),
#    'skype': _("Skype is a user-friendly video chat tool made by Microsoft for all ages.\n"
#               "While it's Linux support often drags behind the latest version,\n"
#               "it is still widely popular and well-known, allowing you to converse\n"
#               "with the ones you love"),
    'spotify': _("Spotify is a widely popular music, podcast, and video streaming service.\n"
                 "It offers millions of songs and sound tracks, all available for free.\n"
                 "However, a paid subscription is required to download the songs and listen to them\n"
                 "offline."),
    'visual': _("Compton is a lightweight, standalone composite manager,\n"
                "suitable for use with window managers that do not natively\n"
                "provide compositing functionality. Compton itself is a fork\n"
                "of xcompmgr-dana, which in turn is a fork of xcompmgr.\n"
                "See the compton github page for further information."),
    'vlc': _("VLC is often considered the ultimate media player, no matter\n"
             "what system you use. It is highly versitile, and can play almost any\n"
             "media format imaginable, even damaged ones. If you ever have a problem\n"
             "with videos or music, VLC can likely solve it."),
    'nemo': _("NOTE: IF YOU ARE UNSURE EXACTLY OF WHAT NEMO IS, IT IS ADVISED TO\n"
              "NOT ENABLE THIS FEATURE.\n"
              "That said, Nemo is the default file manager for the Cinnamon desktop.\n"
              "It is praised for it's features, but does not compare to Konquerer,\n"
              "the KDE file manager."),
    'nixnote': _("Nixnote, (formerly Nevernote) is an opensource client for Evernote,\n"
                 "allowing you to track your digital life in a single, convenient place.\n"
                 "NOTE: an Evernote account is required for cloud synchronization."),
    'wallpapers': _("Installs a program known as Variety, an easy way to automatically\n"
                    "change your wallpaper from thousands of high-quality, free images each day."),
    'wine': _("Easily run several Windows programs on Linux - safely. Wine offers a simple,\n"
              "non-technical method of installing Windows software. Simply download the desired\n"
              ".exe file like you normally would for Windows, and then right click to run using\n"
              "Wine. It's as easy as that.\n"
              "NOTE: NOT ALL PROGRAMS WILL WORK WITH WINE, ALTHOUGH THE MAJORITY DO"),
    'nautilus': _("NOTE: IF YOU ARE UNSURE EXACTLY OF WHAT NAUTILUS IS, IT IS ADVISED TO\n"
              "NOT ENABLE THIS FEATURE.\n"
              "That said, Nautilus is the default file manager for the Gnome desktop.\n"
              "It is praised for it's ease of use, and currently has a few more\n"
              "features than Deepin's file manager.")}

# Delete previous _() dummy declaration
del _
