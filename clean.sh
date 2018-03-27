#!/bin/bash
set -e
#
##########################################################
# Author 	: 	Palanthis (palanthis@gmail.com)
# Website 	: 	http://github.com/Palanthis
# License	:	Distributed under the terms of GNU GPL v3
# Warning	:	These scripts come with NO WARRANTY!!!!!!
##########################################################

echo
echo "Removing work directory!"
rm -rf work
echo "Removed!"

echo
echo "Removing out directory!"
rm -rf out
echo "Removed!"

echo
echo "Cleaning pacman caches before new build!"
pacman -Scc --noconfirm --quiet
echo "Cleaned!"

echo
echo "Ensuring package cache is truly clean!"
rm -rf /var/cache/pacman/pkg/*
echo "All gone!"

echo
echo "Resyncing databases before new build!"
pacman -Syy --quiet
echo "Sync'd!"

echo
echo "All done! You are now ready to build!"
echo



