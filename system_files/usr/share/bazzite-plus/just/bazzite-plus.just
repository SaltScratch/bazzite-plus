[private]
default:
    @just --list

# Post-install setup
[group('Install')]
bazzite-plus-post-install: bazzite-plus-configure-firefox bazzite-plus-download-horizon-client bazzite-plus-configure-desktop bazzite-plus-configure-extensions bazzite-plus-mount-drives && bazzite-plus-install-horizon-client

# Configure Firefox
[group('Setup')]
bazzite-plus-configure-firefox:
  #!/usr/bin/env bash
  set -euo pipefail

  # get user to login to FF first
  echo 'If you have not already done so, Open Firefox, login and close before continuing.'
  echo "Press any key to continue..."
  read -s -n 1

  # find firefox profile and copy user.js to it
  echo "Configuring Firefox..."
  PROFPATH=$(grep 'Path=' $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/profiles.ini | sed s/^Path=// | grep release)
  cp /usr/share/bazzite-plus/firefox/user.js $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/$PROFPATH/

# Copy config files
[group('Setup')]
bazzite-plus-copy-config-files:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Copying config files..."
  cp -r /usr/share/bazzite-plus/user-config/ $HOME/

# Download Horizon Client
[group('Install')]
bazzite-plus-download-horizon-client:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Downloading Horizon Client..."
  wget -O /tmp/horizon-client.rpm https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
  echo "Horizon Client download complete."

# Install Horizon Client
[group('Install')]
bazzite-plus-install-horizon-client:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Horizon Client..."
  sudo rpm-ostree install /tmp/horizon-client.rpm
  echo "Horizon Client installation complete. You will need to reboot to see it."

# Configure Desktop
[group('Setup')]
bazzite-plus-configure-desktop:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Configuring desktop..."
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
  gsettings set org.gnome.desktop.interface cursor-size 48

  # configure gnome display settings
  gdctl set \
    --logical-monitor --primary --monitor DP-2 --scale 1.75 \
    --logical-monitor --monitor HDMI-1 --right-of DP-2 --scale 1.75

# Configure Extensions
[group('Setup')]
bazzite-plus-configure-extensions:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Configuring extensions..."

  dconf write /org/gnome/shell/extensions/dash-to-panel/multi-monitors false
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-positions \''{"PHL-0x00000648":"LEFT","PHL-0x0000092a":"LEFT"}'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-sizes \''{"PHL-0x00000648":56,"PHL-0x0000092a":56}'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/dot-position \''LEFT'\'
  dconf write /org/gnome/shell/extensions/dash-to-panel/panel-element-positions \''{"PHL-0x00000648":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"PHL-0x0000092a":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'\'

# Mount drives
[group('Setup')]
bazzite-plus-mount-drives:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Mounting drives..."

  sudo mkdir /mnt/games
  sudo su -c "echo '/dev/disk/by-label/games /mnt/games auto nosuid,nodev,nofail,x-gvfs-show 0 0' >> /etc/fstab"
  sudo systemctl daemon-reload
  sudo mount -a

# Setup Git
[group('Setup')]
bazzite-plus-setup-git:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Setting up Git config..."

  # Ask for Git username and email
  read -p "Enter your Git username: " git_username
  read -p "Enter your Git email: " git_email

  # Configure Git
  git config --global color.ui true
  git config --global user.name "$git_username"
  git config --global user.email "$git_email"

  echo "Git setup complete"
