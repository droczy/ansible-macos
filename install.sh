#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Helper functions
info()    { echo -e "${BLUE}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[OK]${RESET}    $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

# OS check
if [[ "$(uname -s)" != "Darwin" ]]; then
  error "This script is macOS only."
fi

# Sudo keepalive
info "Requesting sudo access..."
sudo -v
while true; do sudo -v; sleep 60; done &
SUDO_PID=$!

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  waited=0
  until xcode-select -p &>/dev/null; do
    if (( waited >= 900 )); then
      error "Xcode Command Line Tools installation timed out. Run the script again."
    fi
    sleep 5
    waited=$((waited + 5))
  done
  success "Xcode Command Line Tools installed."
else
  success "Xcode Command Line Tools already installed."
fi

# Install Homebrew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! command -v brew &>/dev/null; then
    error "Homebrew installation failed."
  fi
  success "Homebrew installed."
else
  success "Homebrew already installed."
fi

# Install Ansible
if ! command -v ansible &>/dev/null; then
  info "Installing Ansible..."
  brew install ansible
  if ! command -v ansible &>/dev/null; then
    error "Ansible installation failed."
  fi
  success "Ansible installed."
else
  success "Ansible already installed."
fi

# Clone or update repository
if ! [[ -d ~/ansible-macos ]]; then
  info "Cloning repository..."
  git clone https://github.com/droczy/ansible-macos ~/ansible-macos || error "Failed to clone repository."
else
  info "Repository already exists, pulling latest changes..."
  git -C ~/ansible-macos pull || error "Failed to pull repository."
fi
success "Ansible repository ready."

# Kill sudo keepalive
kill $SUDO_PID

# Start Ansible playbook
ansible-playbook ~/ansible-macos/setup.yml -v
