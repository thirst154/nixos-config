# nixos-config

NixOS flake for **thinkpad** — GNOME desktop with home-manager.

## Structure

```
flake.nix              # flake entry point, inputs & outputs
hosts/thinkpad/        # machine-specific: hardware, boot, users
modules/
  nixos/               # system-wide modules
    core.nix             # nix settings, locale, fonts, base packages
    desktop.nix          # GDM + GNOME, pipewire, portals
    development.nix      # langs & tooling (python, node, rust, go, docker)
    programs.nix         # editors, terminal, media, AI tools
  home/                # home-manager user modules
    default.nix          # imports + cursor/gtk theme
    shell.nix            # zsh, fzf, zoxide, aliases
    ghostty.nix          # ghostty terminal config
    git.nix              # git user config
    gtk.nix              # GTK font & extraConfig
```

## Usage

```sh
sudo nixos-rebuild switch --flake .#thinkpad
```
