#!/bin/bash

shopt -s nullglob

_OUT_DIR="$1"
_WORK_DIR="$2"
_SCRIPT_DIR="$3"

for mo_file in ${_OUT_DIR}/trans/cnchi_updater/*.mo
do
	fullname="$(basename ${mo_file})"
	#echo "${fullname}"
	fname="${fullname%.*}"
	#echo "${fname}"
	dest="${_SCRIPT_DIR}/root-image/usr/share/locale/${fname}/LC_MESSAGES"
	echo "${dest}"
	if ! [[ -d "${dest}" ]]; then
		mkdir -p "${dest}";
	fi
	mv "${mo_file}" "${dest}/CNCHI_UPDATER.mo"
done

shopt -u nullglob

exit 0;
