#!/bin/bash

set -ouex pipefail

### Install packages

# horizon client
#wget https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
#dnf5 install -y Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
#rm Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm

# Run installation scripts
/tmp/build/scripts/install-rpms.sh

# flatpaks
flatpak install -y --system flathub org.mozilla.Thunderbird
flatpak install -y --system flathub com.nextcloud.desktopclient.nextcloud
flatpak install -y --system flathub io.github.Faugus.faugus-launcher
flatpak install -y --system flathub org.libreoffice.LibreOffice
flatpak install -y --system flathub io.github.flattool.Ignition
flatpak install -y --system flathub com.github.tchx84.Flatseal
flatpak install -y --system com.mattjakeman.ExtensionManager 
flatpak install -y --system org.mozilla.firefox 
flatpak install -y --system org.gnome.baobab 
flatpak install -y --system org.videolan.VLC

# remove other flatpaks
flatpak remove -y org.gnome.Calendar
flatpak remove -y org.gnome.Contacts   

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket
