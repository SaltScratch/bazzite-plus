#!/bin/bash

set -ouex pipefail

# Run installation scripts
/tmp/build/scripts/install-rpms.sh
/tmp/build/scripts/install-flatpaks.sh
/tmp/build/scripts/just-files.sh
