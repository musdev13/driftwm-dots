#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/install"

source "$INSTALL_DIR/common.sh"
source "$INSTALL_DIR/link_dotconfigs.sh"
source "$INSTALL_DIR/link_usr_bin.sh"
source "$INSTALL_DIR/link_wallpapers.sh"
source "$INSTALL_DIR/link_etc.sh"
source "$INSTALL_DIR/main.sh"

main "$@"
