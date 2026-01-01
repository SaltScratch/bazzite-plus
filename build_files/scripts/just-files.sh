#!/usr/bin/bash

log() {
  echo "=== $* ==="
}

log "Adding just recipes"

echo "import \"/usr/share/bazzite-plus/just/bazzite-plus.just\"" >>/usr/share/ublue-os/justfile
