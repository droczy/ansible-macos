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


# Get sudo access
read -s -p "Enter sudo password: " SUDO_PASS
echo

info "Requesting sudo access..."
echo "$SUDO_PASS" | sudo -S -v

while true; do sudo -v; sleep 60; done &
SUDO_PID=$!
trap 'sudo rm -f /etc/sudoers.d/ansible-install' EXIT


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


# Start Ansible playbook
echo "$USER ALL=(ALL) SETENV: NOPASSWD: /usr/sbin/installer" | sudo tee /etc/sudoers.d/ansible-install > /dev/null
ansible-playbook ~/ansible-macos/setup.yml --extra-vars "ansible_become_password=$SUDO_PASS"

success "Ansible playbook completed successfully."

cat <<'EOF'
==============================================================
|                        SETUP SUCCESS                       |
==============================================================
| Status : OK                                                |
| Result : All tasks completed                               |
| Next   : Reboot recommended                                |
==============================================================
EOF

osascript -e 'display notification "All tasks completed" with title "ansible-macos" subtitle "Setup success"' >/dev/null 2>&1 || true

read -r -p "Restart now? [y/N]: " RESTART_CHOICE
if [[ "$RESTART_CHOICE" =~ ^([yY]|[yY][eE][sS])$ ]]; then
  info "Restarting now..."
  sudo shutdown -r now
else
  info "Restart skipped. Reboot later with: sudo shutdown -r now"
fi
