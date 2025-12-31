#!/bin/bash

set -ouex pipefail

### Install packages

# horizon client
#wget https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
#dnf5 install -y Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
#rm Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm

# Run installation scripts
/tmp/build/scripts/install-rpms.sh
/tmp/build/scripts/install-flatpaks.sh
#/tmp/build/scripts/remove-flatpaks.sh

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket
