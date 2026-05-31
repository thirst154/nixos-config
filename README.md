# nixos-config

NixOS flake for **thinkpad** — a ThinkPad laptop running NixOS unstable with a dual-desktop setup (GNOME + Hyprland) managed via Home Manager.

## Features

- **Dual desktop environment**: GNOME (via GDM) and Hyprland (Wayland compositor)
- **UK keyboard layout** everywhere: console, X11/GDM, and Hyprland
- **ThinkPad-specific tweaks**: TLP for power management, Bluetooth with blueman, libinput touchpad
- **Development-ready**: Python, Node.js, Rust, Go, C/C++, Docker, and language servers
- **Custom apps from flakes**: Ghostty terminal and Helium browser
- **Pretty shell**: Zsh with Oh My Zsh (lambda theme), autosuggestions, syntax highlighting, fzf, zoxide, and direnv
- **Nix hygiene**: Weekly GC, nightly store optimisation, 10-generation boot limit, trusted-user permissions

## Structure

```
flake.nix              # flake entry point, inputs & outputs, formatter
hosts/thinkpad/
  default.nix          # machine-specific: hostname, boot, users, keyboard, bluetooth, TLP
  hardware-configuration.nix  # auto-generated hardware config
modules/
  nixos/               # system-wide modules
    core.nix             # nix settings, locale, fonts, trusted-users, base packages
    desktop.nix          # GDM + GNOME, Hyprland, pipewire, portals, keyring
    development.nix      # languages & tooling (python, node, rust, go, docker)
    programs.nix         # editors, terminal, media, AI tools
  home/                # home-manager user modules
    default.nix          # imports + cursor/gtk theme settings
    shell.nix            # zsh, oh-my-zsh, fzf, zoxide, direnv, aliases
    ghostty.nix          # ghostty terminal config (Rose Pine theme)
    git.nix              # git user config
    gtk.nix              # GTK font & extraConfig
    hyprland.nix         # Hyprland window manager config + keybinds
    waybar.nix           # Waybar status bar (workspaces, battery, audio, etc.)
    mako.nix             # Mako notification daemon
    wofi.nix             # Wofi launcher config & theme
rebuild.sh             # helper script: format, diff, rebuild, commit, notify
```

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | NixOS unstable channel |
| `home-manager` | User environment management |
| `ghostty` | GPU-accelerated terminal emulator |
| `alejandra` | Nix formatter |
| `helium` | Custom web browser |
| `ghostty` | GPU-accelerated terminal emulator |

## Usage

### Build & switch

```sh
sudo nixos-rebuild switch --flake .#thinkpad
```

### Format

```sh
nix fmt
```

### Automated rebuild script

```sh
./rebuild.sh
```

This will:
1. Check for changes in `*.nix` and `flake.lock`
2. Auto-format with Alejandra
3. Show a diff
4. Rebuild the system
5. Commit the changes with generation metadata
6. Send a desktop notification on success

## Keybinds (Hyprland)

| Key | Action |
|-----|--------|
| `Super + Enter` | Open Ghostty terminal |
| `Super + Space` | Toggle Vicinae launcher |
| `Super + E` | Open file manager (Nautilus) |
| `Super + C` | Close active window |
| `Super + M` | Exit Hyprland |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + Arrow Keys` | Change focus |
| `Super + Shift + Arrow Keys` | Move window |
| `Super + Ctrl + Arrow Keys` | Resize window |
| `Super + [1-0]` | Switch workspace |
| `Super + Shift + [1-0]` | Move window to workspace |
| `Super + Left Click` | Drag window |
| `Super + Right Click` | Resize window |

## Notable Configurations

- **State versions**: NixOS `24.11`, Home Manager `26.05`
- **Home Manager**: Uses global pkgs and user packages, with `.hm-backup` file extension for collisions
- **Vicinae cachix**: Binary cache configured for faster builds
- **Docker**: User is in the `docker` group; Docker daemon is enabled system-wide
- **GPG Agent**: Enabled for signing and key management
- **GNOME Keyring**: Enabled for secret storage
