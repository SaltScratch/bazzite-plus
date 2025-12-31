#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# horizon client
wget https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
dnf5 install -y Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
rm Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm

# flatpaks
flatpak install -y --system flathub org.mozilla.Thunderbird
flatpak install -y --system flathub com.nextcloud.desktopclient.nextcloud
flatpak install -y --system flathub com.visualstudio.code
flatpak install -y --system flathub io.github.Faugus.faugus-launcher
flatpak install -y --system flathub org.libreoffice.LibreOffice
flatpak install -y --system flathub io.github.flattool.Ignition
flatpak install -y --system flathub com.github.tchx84.Flatseal
flatpak install -y --system com.mattjakeman.ExtensionManager 
flatpak install -y --system org.mozilla.firefox 
flatpak install -y --system org.gnome.baobab 
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

systemctl enable podman.socket
