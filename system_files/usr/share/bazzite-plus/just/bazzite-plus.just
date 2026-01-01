[private]
default:
    @just --list

# Post-install setup
[group('Install')]
bazzite-plus-post-install: bazzite-plus-install-horizon-client bazzite-plus-configure-extensions bazzite-plus-mount-drives
  echo "Post-install setup complete!"

# Install Horizon Client
[group('Install')]
bazzite-plus-install-horizon-client:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Horizon Client..."
  wget https://download3.omnissa.com/software/CART26FQ4_LIN64_RPMPKG_2512/Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
  sudo rpm-ostree install Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
  rm Omnissa-Horizon-Client-2512-8.17.0-20187591429.x64.rpm
  echo "Horizon Client installation complete. You will need to reboot to see it."

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

  if [ ! -f "${HOME}/.ssh/id_ed25519.pub" ]; then
    # Generate SSH key
    echo "SSH key not found"
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$git_email"

    # Display the public key
    echo "Your SSH public key:"
    cat ${HOME}/.ssh/id_ed25519.pub
  else
    echo "Using existing SSH key ~/.ssh/id_ed25519.pub"
    # TODO: Improve this
    echo "Manually verify that your email $git_email matches SSH key"
  fi

  echo "Setup GPG to use SSH key"
  git config --global gpg.format ssh;
  # Make SSH key inline, this allows us to use containers much easier with ssh
  git config --global user.signingkey "key::$(cat ${HOME}/.ssh/id_ed25519.pub)";
  git config --global commit.gpgSign true


  echo "Setup aliases"
  git config --global alias.add-nowhitespace '!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -';
  git config --global alias.graph 'log --decorate --oneline --graph';
  git config --global alias.ll 'log --oneline';
  git config --global alias.prune-all '!git remote | xargs -n 1 git remote prune';
  git config --global alias.pullr 'pull --rebase';
  git config --global alias.pushall '!git remote | xargs -L1 git push --all';
  git config --global alias.pushfwl 'push --force-with-lease';

  echo "Various QoL configs"
  # Improve git for big repos (makes older libgit2 not work correctly)
  git config --global feature.manyFiles true;
  git config --global init.defaultBranch main;

  echo "Create global .gitignore"

  git config --global core.excludesFile '~/.gitignore'

  echo "Git setup complete"
