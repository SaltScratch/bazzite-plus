#!/bin/bash
set -euo pipefail

echo "=== Installing Flatpaks ==="

FLATPAK_FILE="/tmp/build/packages/flatpaks"

if [ ! -f "$FLATPAK_FILE" ]; then
    echo "No flatpak list found, skipping..."
    exit 0
fi

# Install flatpaks during build with error tracking
FAILED_APPS=""
grep -vE '^\s*(#|$)' "$FLATPAK_FILE" | while read -r app; do
    echo "Installing $app..."
    if ! flatpak install -y --system flathub "$app"; then
        FAILED_APPS="$FAILED_APPS $app"
    fi
done

[ -n "$FAILED_APPS" ] && echo "WARNING: Failed to install:$FAILED_APPS"

echo "Flatpak installation complete!"

rm -rf /var/tmp/flatpak-cache-*