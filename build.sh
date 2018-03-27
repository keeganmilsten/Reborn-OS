#!/bin/bash

set -e -u


if [ -f config ]; then
    source ./config
else
    # No config file!
    exit 1
fi

iso_name=Reborn-OS
iso_label="Reborn-OS_$(date +%Y%m)"
iso_version=$(date +%Y.%m.%d)
install_dir=arch
work_dir=work
out_dir=out
gpg_key=

arch=$(uname -m)
verbose=""
script_path=$(readlink -f ${0%/*})

_usage ()
{
    echo "usage ${0} [options]"
    echo
    echo " General options:"
    echo "    -N <iso_name>      Set an iso filename (prefix)"
    echo "                        Default: ${iso_name}"
    echo "    -V <iso_version>   Set an iso version (in filename)"
    echo "                        Default: ${iso_version}"
    echo "    -L <iso_label>     Set an iso label (disk label)"
    echo "                        Default: ${iso_label}"
    echo "    -D <install_dir>   Set an install_dir (directory inside iso)"
    echo "                        Default: ${install_dir}"
    echo "    -w <work_dir>      Set the working directory"
    echo "                        Default: ${work_dir}"
    echo "    -o <out_dir>       Set the output directory"
    echo "                        Default: ${out_dir}"
    echo "    -v                 Enable verbose output"
    echo "    -h                 This help message"
    exit ${1}
}

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e ${work_dir}/build.${1}_${arch} ]]; then
        $1
        touch ${work_dir}/build.${1}_${arch}
    fi
}

# Setup custom pacman.conf with current cache directories.
make_pacman_conf() {
    local _cache_dirs
    _cache_dirs=($(pacman -v 2>&1 | grep '^Cache Dirs:' | sed 's/Cache Dirs:\s*//g'))
sed -r "s|^#?\\s*CacheDir.+|CacheDir = $(echo -n ${_cache_dirs[@]})|g" ${script_path}/pacman.conf > ${work_dir}/pacman.conf
}

# Base installation, plus needed packages (airootfs)
make_basefs() {
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" init
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" -p "haveged intel-ucode memtest86+ mkinitcpio-nfs-utils nbd" install
}

# Additional packages (airootfs)
make_packages() {
     setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" -p "$(grep -h -v ^# ${script_path}/packages.{both,${arch}})" install
}

# Needed packages for x86_64 EFI boot
make_packages_efi() {
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" -p "efitools efibootmgr" install
}
# Copy mkinitcpio archiso hooks and build initramfs (airootfs)
make_setup_mkinitcpio() {
    local _hook
    mkdir -p ${work_dir}/${arch}/airootfs/etc/initcpio/hooks
    mkdir -p ${work_dir}/${arch}/airootfs/etc/initcpio/install
    for _hook in archiso archiso_shutdown archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_loop_mnt; do
        cp /usr/lib/initcpio/hooks/${_hook} ${work_dir}/${arch}/airootfs/etc/initcpio/hooks
        cp /usr/lib/initcpio/install/${_hook} ${work_dir}/${arch}/airootfs/etc/initcpio/install
    done
    sed -i "s|/usr/lib/initcpio/|/etc/initcpio/|g" ${work_dir}/${arch}/airootfs/etc/initcpio/install/archiso_shutdown
    cp /usr/lib/initcpio/install/archiso_kms ${work_dir}/${arch}/airootfs/etc/initcpio/install
    cp /usr/lib/initcpio/archiso_shutdown ${work_dir}/${arch}/airootfs/etc/initcpio
    cp ${script_path}/mkinitcpio.conf ${work_dir}/${arch}/airootfs/etc/mkinitcpio-archiso.conf
    gnupg_fd=
    if [[ ${gpg_key} ]]; then
      gpg --export ${gpg_key} >${work_dir}/gpgkey
      exec 17<>${work_dir}/gpgkey
    fi
    ARCHISO_GNUPG_FD=${gpg_key:+17} setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" -r 'mkinitcpio -c /etc/mkinitcpio-archiso.conf -k /boot/vmlinuz-linux -g /boot/archiso.img' run
    if [[ ${gpg_key} ]]; then
      exec 17<&-
    fi
}
# Customize installation (airootfs)
make_customize_airootfs() {
   cp -af ${script_path}/airootfs ${work_dir}/${arch}
    curl -o ${work_dir}/${arch}/airootfs/etc/pacman.d/mirrorlist 'https://www.archlinux.org/mirrorlist/?country=all&protocol=http&use_mirror_status=on'
    lynx -dump -nolist 'https://wiki.archlinux.org/index.php/Installation_Guide?action=render' >> ${work_dir}/${arch}/airootfs/root/install.txt
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}/${arch}" -C "${work_dir}/pacman.conf" -D "${install_dir}" -r '/root/customize_airootfs.sh' run
    rm ${work_dir}/${arch}/airootfs/root/customize_airootfs.sh
    rm -f ${work_dir}/${arch}airootfs/etc/xdg/autostart/vboxclient.desktop
        if [ -f "${work_dir}/${arch}/airootfs/etc/xdg/autostart/pamac-tray.desktop" ]; then
            rm ${work_dir}/${arch}/airootfs/etc/xdg/autostart/pamac-tray.desktop
        fi
        ln -sf /usr/share/zoneinfo/UTC ${work_dir}/${arch}/airootfs/etc/localtime
        chmod 750 ${work_dir}/${arch}/airootfs/etc/sudoers.d
        chmod 440 ${work_dir}/${arch}/airootfs/etc/sudoers.d/g_wheel
cp -L ${script_path}/set_password ${work_dir}/${arch}/airootfs/usr/bin
}
####################################################################################
# Install cnchi installer from Git
make_cnchi() {
    echo
    echo ">>> Warning! Installing Cnchi Installer from GIT (${CNCHI_GIT_BRANCH} branch)"
    wget "${CNCHI_GIT_URL}" -O ${script_path}/cnchi-git.zip
    unzip ${script_path}/cnchi-git.zip -d ${script_path}
    rm -f ${script_path}/cnchi-git.zip
    CNCHI_SRC="${script_path}/Cnchi-${CNCHI_GIT_BRANCH}"
        install -d ${work_dir}/${arch}/airootfs/usr/share/{cnchi,locale}
	install -Dm755 "${CNCHI_SRC}/bin/cnchi" "${work_dir}/${arch}/airootfs/usr/bin/cnchi"
	install -Dm755 "${CNCHI_SRC}/cnchi.desktop" "${work_dir}/${arch}/airootfs/usr/share/applications/cnchi.desktop"
	install -Dm644 "${CNCHI_SRC}/data/images/antergos/antergos-icon.png" "${work_dir}/${arch}/airootfs/usr/share/pixmaps/cnchi.png"
    # TODO: This should be included in Cnchi's src code as a separate file
    # (as both files are needed to run cnchi)
    sed -r -i 's|\/usr.+ -v|pkexec /usr/share/cnchi/bin/cnchi -s bugsnag|g' "${work_dir}/${arch}/airootfs/usr/bin/cnchi"
    for i in ${CNCHI_SRC}/cnchi ${CNCHI_SRC}/bin ${CNCHI_SRC}/data ${CNCHI_SRC}/scripts ${CNCHI_SRC}/ui; do
        cp -R ${i} "${work_dir}/${arch}/airootfs/usr/share/cnchi/"
    done
    for files in ${CNCHI_SRC}/po/*; do
        if [ -f "$files" ] && [ "$files" != 'po/cnchi.pot' ]; then
            STRING_PO=`echo ${files#*/}`
            STRING=`echo ${STRING_PO%.po}`
            mkdir -p ${work_dir}/${arch}/airootfs/usr/share/locale/${STRING}/LC_MESSAGES
            msgfmt $files -o ${work_dir}/${arch}/airootfs/usr/share/locale/${STRING}/LC_MESSAGES/cnchi.mo
            echo "${STRING} installed..."
            echo "CNCHI IS NOW BUILT"
        fi
    done
}
########################################################################################

make_fixes() {
	# Remove Antergos gsettings file
#	rm ${work_dir}/${arch}/airootfs/usr/share/glib-2.0/schemas/90_deepin-default-gsettings.gschema.override
	echo "ANTERGOS GSETTINGS REMOVED"
        # Setup gsettings if gsettings folder exists
        if [ -d ${script_path}/gsettings ]; then
            # Copying GSettings XML schema files
            mkdir -p ${work_dir}/${arch}/airootfs/usr/share/glib-2.0/schemas
            for _schema in ${script_path}/gsettings/*.gschema.override; do
                echo ">>> Will use ${_schema}"
                cp ${_schema} ${work_dir}/${arch}/airootfs/usr/share/glib-2.0/schemas
            done
            # Compile GSettings XML schema files
            ${work_dir}/${arch}/airootfs/usr/bin/glib-compile-schemas ${work_dir}/${arch}/airootfs/usr/share/glib-2.0/schemas
        fi
#Use lightdm.conf from local direcectory instead of default one
echo "Removing unnecessary lightdm.conf"
rm ${work_dir}/${arch}/airootfs/etc/lightdm/lightdm.conf
echo "Copying correct lightdm.conf file over"
cp ${script_path}/airootfs/etc/lightdm/lightdm.conf ${work_dir}/${arch}/airootfs/etc/lightdm/
echo "DONE"
#Use sddm.conf from local direcectory instead of default one
echo "Removing unnecessary sddm.conf"
rm ${work_dir}/${arch}/airootfs/etc/sddm.conf
echo "Copying correct sddm.conf file over"
cp ${script_path}/airootfs/etc/sddm.conf ${work_dir}/${arch}/airootfs/etc/
echo "DONE"
#Copy Antergos Mirrorlist
echo "Setting up Antergos and Reborn Mirrorlist"
mkdir -p ${work_dir}/${arch}/airootfs/etc/pacman.d
cp ${script_path}/airootfs/etc/antergos-mirrorlist ${work_dir}/${arch}/airootfs/etc/pacman.d/
cp ${script_path}/airootfs/etc/reborn-mirrorlist ${work_dir}/${arch}/airootfs/etc/pacman.d/
echo "DONE"
#Copy pacman-init.service over
echo "Copying pacman-init.service"
cp ${script_path}/pacman-init.service ${work_dir}/${arch}/airootfs/etc/systemd/system/
echo "DONE"
#Replace pacman.conf with my own
echo "Replacing pacman.conf with my own"
rm ${work_dir}/${arch}/airootfs/etc/pacman.conf
cp ${script_path}/pacman.conf ${work_dir}/${arch}/airootfs/etc/
echo "DONE"
#Editting Cnchi
echo "Moving Cnchi files over..."
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/packages.xml
cp ${script_path}/Cnchi/packages.xml ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/pacman.tmpl
cp ${script_path}/Cnchi/pacman.tmpl ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/
cp ${script_path}/Cnchi/pacman2.tmpl ${work_dir}/${arch}/airootfs/usr/share/cnchi/
rm ${work_dir}/${arch}/airootfs/usr/share/applications/cnchi.desktop
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/features_info.py
cp ${script_path}/Cnchi/features_info.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/features.py
cp ${script_path}/Cnchi/features.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/desktop_info.py
cp ${script_path}/Cnchi/desktop_info.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/encfs.py
cp ${script_path}/Cnchi/encfs.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/installation/boot/grub2.py
cp ${script_path}/Cnchi/grub2.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/installation/boot/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/scripts/10_antergos
cp ${script_path}/Cnchi/10_antergos ${work_dir}/${arch}/airootfs/usr/share/cnchi/scripts/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/installation/boot/systemd_boot.py
cp ${script_path}/Cnchi/systemd_boot.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/installation/boot/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/scripts/postinstall.sh
cp ${script_path}/Cnchi/postinstall.sh ${work_dir}/${arch}/airootfs/usr/share/cnchi/scripts/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/main_window.py
cp ${script_path}/Cnchi/main_window.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/show_message.py
cp ${script_path}/Cnchi/show_message.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/slides.py
cp ${script_path}/Cnchi/slides.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/timezone.py
cp ${script_path}/Cnchi/timezone.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/welcome.py
cp ${script_path}/Cnchi/welcome.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/desktop.py
cp ${script_path}/Cnchi/desktop.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/antergos/antergos-logo-mini2.png
cp ${script_path}/Cnchi/antergos-logo-mini2.png ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/antergos/
cp ${script_path}/Cnchi/20-intel.conf ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/lightdm-webkit2-greeter.conf ${work_dir}/${arch}/airootfs/usr/share/cnchi/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/1.png
cp ${script_path}/Cnchi/1.png ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/2.png
cp ${script_path}/Cnchi/2.png ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/
rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/3.png
cp ${script_path}/Cnchi/3.png ${work_dir}/${arch}/airootfs/usr/share/cnchi/data/images/slides/
cp ${script_path}/Cnchi/sddm.conf ${work_dir}/${arch}/airootfs/usr/share/cnchi/
rm ${work_dir}/${arch}/airootfs/usr/share/pixmaps/cnchi.png
cp ${script_path}/airootfs/usr/share/applications/cnchi.png ${work_dir}/${arch}/airootfs/usr/share/pixmaps/
cp ${script_path}/Cnchi/flatpak.sh ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/pkcon.sh ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/pkcon2.sh ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/flatpak.desktop ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/pacman.conf ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp ${script_path}/Cnchi/update.desktop ${work_dir}/${arch}/airootfs/usr/share/cnchi/
echo "DONE"
}
# Prepare kernel/initramfs ${install_dir}/boot/
make_boot() {
    mkdir -p ${work_dir}/iso/${install_dir}/boot/${arch}
    cp ${work_dir}/${arch}/airootfs/boot/archiso.img ${work_dir}/iso/${install_dir}/boot/${arch}/archiso.img
    cp ${work_dir}/${arch}/airootfs/boot/vmlinuz-linux ${work_dir}/iso/${install_dir}/boot/${arch}/vmlinuz
}
# Add other aditional/extra files to ${install_dir}/boot/
make_boot_extra() {
    cp ${work_dir}/${arch}/airootfs/boot/memtest86+/memtest.bin ${work_dir}/iso/${install_dir}/boot/memtest
    cp ${work_dir}/${arch}/airootfs/usr/share/licenses/common/GPL2/license.txt ${work_dir}/iso/${install_dir}/boot/memtest.COPYING
    cp ${work_dir}/${arch}/airootfs/boot/intel-ucode.img ${work_dir}/iso/${install_dir}/boot/intel_ucode.img
    cp ${work_dir}/${arch}/airootfs/usr/share/licenses/intel-ucode/LICENSE ${work_dir}/iso/${install_dir}/boot/intel_ucode.LICENSE
}
# Prepare /${install_dir}/boot/syslinux
make_syslinux() {
    mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux
    for _cfg in ${script_path}/syslinux/*.cfg; do
        sed "s|%ARCHISO_LABEL%|${iso_label}|g;
             s|%INSTALL_DIR%|${install_dir}|g" ${_cfg} > ${work_dir}/iso/${install_dir}/boot/syslinux/${_cfg##*/}
    done
    cp ${script_path}/syslinux/splash.png ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/*.c32 ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/lpxelinux.0 ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/memdisk ${work_dir}/iso/${install_dir}/boot/syslinux
    mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux/hdt
    gzip -c -9 ${work_dir}/${arch}/airootfs/usr/share/hwdata/pci.ids > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/pciids.gz
    gzip -c -9 ${work_dir}/${arch}/airootfs/usr/lib/modules/*-ARCH/modules.alias > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/modalias.gz
}
# Prepare /isolinux
make_isolinux() {
    mkdir -p ${work_dir}/iso/isolinux
    sed "s|%INSTALL_DIR%|${install_dir}|g" ${script_path}/isolinux/isolinux.cfg > ${work_dir}/iso/isolinux/isolinux.cfg
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/isolinux.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/isohdpfx.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/${arch}/airootfs/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}/iso/isolinux/
}
# Prepare /EFI
make_efi() {
    mkdir -p ${work_dir}/iso/EFI/boot
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/iso/EFI/boot/bootx64.efi
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/iso/EFI/boot/
    cp ${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi ${work_dir}/iso/EFI/boot/loader.efi
    mkdir -p ${work_dir}/iso/loader/entries
    cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/iso/loader/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/iso/loader/entries/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/iso/loader/entries/
    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        ${script_path}/efiboot/loader/entries/archiso-x86_64-usb.conf > ${work_dir}/iso/loader/entries/archiso-x86_64.conf
    # EFI Shell 2.0 for UEFI 2.3+
    curl -o ${work_dir}/iso/EFI/shellx64_v2.efi https://raw.githubusercontent.com/tianocore/edk2/master/ShellBinPkg/UefiShell/X64/Shell.efi
    # EFI Shell 1.0 for non UEFI 2.3+
    curl -o ${work_dir}/iso/EFI/shellx64_v1.efi https://raw.githubusercontent.com/tianocore/edk2/master/EdkShellBinPkg/FullShell/X64/Shell_Full.efi
}
# Prepare efiboot.img::/EFI for "El Torito" EFI boot mode
make_efiboot() {
    mkdir -p ${work_dir}/iso/EFI/archiso
    truncate -s 40M ${work_dir}/iso/EFI/archiso/efiboot.img
    mkfs.vfat -n ARCHISO_EFI ${work_dir}/iso/EFI/archiso/efiboot.img
    mkdir -p ${work_dir}/efiboot
    mount ${work_dir}/iso/EFI/archiso/efiboot.img ${work_dir}/efiboot
    mkdir -p ${work_dir}/efiboot/EFI/archiso
    cp ${work_dir}/iso/${install_dir}/boot/x86_64/vmlinuz ${work_dir}/efiboot/EFI/archiso/vmlinuz.efi
    cp ${work_dir}/iso/${install_dir}/boot/x86_64/archiso.img ${work_dir}/efiboot/EFI/archiso/archiso.img
    cp ${work_dir}/iso/${install_dir}/boot/intel_ucode.img ${work_dir}/efiboot/EFI/archiso/intel_ucode.img
    mkdir -p ${work_dir}/efiboot/EFI/boot
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/efiboot/EFI/boot/bootx64.efi
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/efiboot/EFI/boot/
    cp ${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi ${work_dir}/efiboot/EFI/boot/loader.efi
    mkdir -p ${work_dir}/efiboot/loader/entries
    cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/efiboot/loader/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/efiboot/loader/entries/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/efiboot/loader/entries/
    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        ${script_path}/efiboot/loader/entries/archiso-x86_64-cd.conf > ${work_dir}/efiboot/loader/entries/archiso-x86_64.conf
    cp ${work_dir}/iso/EFI/shellx64_v2.efi ${work_dir}/efiboot/EFI/
    cp ${work_dir}/iso/EFI/shellx64_v1.efi ${work_dir}/efiboot/EFI/
    umount -d ${work_dir}/efiboot
}

# Build airootfs filesystem image
make_prepare() {
    cp -a -l -f ${work_dir}/${arch}/airootfs ${work_dir}
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" pkglist
    setarch ${arch} mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" ${gpg_key:+-g ${gpg_key}} prepare
    rm -rf ${work_dir}/airootfs
    # rm -rf ${work_dir}/${arch}/airootfs (if low space, this helps)
}
# Build ISO
make_iso() {
    mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -o "${out_dir}" iso "${iso_name}-${iso_version}-x86_64.iso"
}
if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    _usage 1
fi
if [[ ${arch} != x86_64 ]]; then
    echo "This script needs to be run on x86_64"
    _usage 1
fi
while getopts 'N:V:L:D:w:o:g:vh' arg; do
    case "${arg}" in
        N) iso_name="${OPTARG}" ;;
        V) iso_version="${OPTARG}" ;;
        L) iso_label="${OPTARG}" ;;
        D) install_dir="${OPTARG}" ;;
        w) work_dir="${OPTARG}" ;;
        o) out_dir="${OPTARG}" ;;
        g) gpg_key="${OPTARG}" ;;
        v) verbose="-v" ;;
        h) _usage 0 ;;
        *)
           echo "Invalid argument '${arg}'"
           _usage 1
           ;;
    esac
done
mkdir -p ${work_dir}
run_once make_pacman_conf

for arch in x86_64; do
    run_once make_basefs
    run_once make_packages
done
run_once make_packages_efi
for arch in x86_64; do
    run_once make_setup_mkinitcpio
    run_once make_customize_airootfs
done
for arch in x86_64; do
    run_once make_boot
done
# Do all stuff for "iso
run_once make_boot_extra
run_once make_syslinux
run_once make_isolinux
run_once make_efi
run_once make_efiboot
run_once make_fixes

for arch in x86_64; do
run_once make_prepare
done
run_once make_iso
