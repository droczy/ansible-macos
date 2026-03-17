#!/usr/bin/env bash

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Helpfunctions
info()    { echo -e "${BLUE}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[OK]${RESET}    $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

# OS check
if [[ "$(uname -s)" != "Darwin" ]]; then
  error "This script is macos only."
fi

# XCode Tools Installation
if ! xcode-select -p &>/dev/null; then
  info "Installiere Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Command Line Tools installiert."
else
  success "Xcode Command Line Tools bereits vorhanden."
fi
