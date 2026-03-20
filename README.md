# ansible-macos

Automated macOS setup using Ansible.

## Requirements

- macOS (Apple Silicon)
- Internet connection

## Usage
```bash
curl -fsSL https://raw.githubusercontent.com/droczy/ansible-macos/main/install.sh -o ~/install.sh && bash ~/install.sh
```

The script will:
1. Install Xcode Command Line Tools
2. Install Homebrew
3. Install Ansible
4. Clone or update this repository
5. Run the Ansible playbook

## Structure
```
├── install.sh                  # Bootstrap script
├── setup.yml                   # Ansible entry point
└── tasks/
    ├── homebrew.yml           # CLI tools
    ├── casks.yml              # GUI applications
    ├── dotfiles.yml           # Dotfiles setup
    └── macos/
        ├── appearance.yml     # UI appearance
        ├── desktop.yml        # Desktop settings
        ├── dock.yml           # Dock preferences
        ├── finder.yml         # Finder preferences
        ├── firewall.yml       # Firewall settings
        ├── hostname.yml       # Hostname settings
        ├── language.yml       # System language
        └── login.yml          # Login screen settings
```

## What gets installed

**CLI Tools:** neovim, ripgrep, fd, tmux, stow, wget, lua-language-server, python-lsp-server, opencode, openjdk, jdtls, zsh-autosuggestions, zsh-syntax-highlighting, wireguard-tools

**Apps:** Alacritty, AeroSpace, Cryptomator, Discord, Elgato Wave Link, Enpass, JetBrains Mono Nerd Font, Karabiner-Elements, LibreWolf, Obsidian, Scroll Reverser, Signal, Synology Drive, Thunderbird

**Homebrew tap:** `nikitabobko/tap` (for AeroSpace)

## macOS configuration

The playbook also applies macOS defaults:

- **Dock:** left position, autohide, no magnification, launch animation disabled, show only active apps, remove pinned apps, recents disabled
- **Finder:** show hidden files, show all extensions, show path/status bars, disable extension warning, use list view by default
- **Appearance:** enable dark mode, set medium sidebar icon size, use dark icon style
- **Language:** set system language to English
- **Desktop:** set solid black wallpaper and disable desktop widgets
- **Login:** hide username list on login screen
- **Firewall:** enable application firewall
- **Hostname:** set ComputerName, HostName, and LocalHostName
