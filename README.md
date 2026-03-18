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
4. Clone this repository
5. Run the Ansible playbook

## Structure
```
├── install.sh          # Bootstrap script
├── setup.yml           # Ansible entry point
└── tasks/
    ├── homebrew.yml           # CLI tools
    ├── casks.yml              # Applications
    ├── dotfiles.yml           # Dotfiles setup
    └── macos/
        ├── dock.yml           # Dock preferences
        ├── finder.yml         # Finder preferences
        ├── appearance.yml     # UI appearance
        ├── language.yml       # System language
        └── wallpaper.yml      # Desktop wallpaper
```

## What gets installed

**CLI Tools:** neovim, ripgrep, fd, tmux, stow, wget, lua-language-server, python-lsp-server, opencode, openjdk, jdtls, zsh-autosuggestions, zsh-syntax-highlighting, wireguard-tools

**Apps:** Librewolf, Obsidian, Thunderbird, Karabiner Elements, AeroSpace, Alacritty, Cryptomator, Synology Drive, JetBrains Mono Nerd Font, Enpass

**Homebrew tap:** `nikitabobko/tap` (for AeroSpace)

## macOS configuration

The playbook also applies macOS defaults:

- **Dock:** left position, autohide, no magnification, launch animation disabled, show only active apps, remove pinned apps, recents disabled
- **Finder:** show hidden files, show all extensions, show path/status bars, disable extension warning, use list view by default
- **Appearance:** enable Dark Mode and set medium sidebar icon size
- **Language:** set system language to English
- **Wallpaper:** set solid black wallpaper
