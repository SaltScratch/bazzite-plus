#!/bin/bash
set -euo pipefail

echo "=== Installing RPM packages ==="

# Copy repo files
REPO_DIR="/tmp/build/repos"
if [ -d "$REPO_DIR" ]; then
    echo "Adding custom repositories..."
    cp -v "$REPO_DIR"/*.repo /etc/yum.repos.d/ 2>/dev/null || true
fi

# Read and install packages
PACKAGE_FILE="/tmp/build/packages/rpms"
if [ -f "$PACKAGE_FILE" ]; then
    # Filter out comments and empty lines
    PACKAGES=$(grep -vE '^\s*(#|$)' "$PACKAGE_FILE" | tr '\n' ' ')
    
    if [ -n "$PACKAGES" ]; then
        echo "Installing: $PACKAGES"
        dnf5 install -y $PACKAGES
    fi
fi

echo "RPM installation complete!"
