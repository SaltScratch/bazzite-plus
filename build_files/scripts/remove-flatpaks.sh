#!/bin/bash
set -euo pipefail

echo "=== Removing Flatpaks ==="

FLATPAK_FILE="/tmp/build/packages/flatpaks-to-remove"

if [ ! -f "$FLATPAK_FILE" ]; then
    echo "No flatpak list found, skipping..."
    exit 0
fi

# Remove default flatpaks during build with error tracking
FAILED_APPS=""
grep -vE '^\s*(#|$)' "$FLATPAK_FILE" | while read -r app; do
    echo "Installing $app..."
    if ! flatpak remove -y "$app"; then
        FAILED_APPS="$FAILED_APPS $app"
    fi
done

[ -n "$FAILED_APPS" ] && echo "WARNING: Failed to remove:$FAILED_APPS"

echo "Flatpak removal complete!"
