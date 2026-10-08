# nixos-config

NixOS flake for **thinkpad** — a ThinkPad laptop running NixOS unstable with GNOME, with the user environment managed by Home Manager (running as a NixOS module).

## Features

- **GNOME desktop**: GDM display manager, Blur My Shell extension, WhiteSur-Dark GTK theme, dark mode, custom keybinds and wallpapers via dconf
- **Kitty terminal**: JetBrainsMono Nerd Font, custom USGC-RETICLE theme
- **UK keyboard layout** in console and GNOME
- **ThinkPad-specific tweaks**: TLP power management, Bluetooth with blueman, fingerprint reader (fprintd) for sudo and GDM login, Plymouth boot splash, firmware updates via fwupd/LVFS
- **Everyday ready**: Proton Mail (Bridge + Thunderbird), Proton Pass, printing (CUPS + mDNS/IPP-USB) and scanning (SANE), LocalSend with its firewall port open, Transmission with inbound port open
- **Gaming ready**: Steam, GameMode, Minecraft launchers (ATLauncher, FTB App, Prism Launcher), JDKs 8/17/21
- **Development-ready**: Python, Node.js/TypeScript, Rust, Go, C/C++, Elixir, and Lua toolchains each with language servers; full Go linting toolchain (golangci-lint, gosec, gotools, gomodifytags, impl); DBeaver and Bruno for databases/APIs; Docker and libvirtd (GNOME Boxes) for virtualisation
- **Apps from flakes**: Helium browser (patched for Wayland) and the alejandra formatter
- **Pretty shell**: Zsh with Oh My Zsh (lambda theme), autosuggestions, syntax highlighting, fzf, zoxide, and direnv
- **AI tooling**: opencode (TUI themed with a USGC-RETICLE port) and t3code
- **Nix hygiene**: weekly GC (older than 30d), nightly store optimisation, 10-generation boot limit, trusted-user permissions

## Structure

```
flake.nix              # flake entry point: inputs, outputs, formatter, home-manager wiring
hosts/thinkpad/
  default.nix          # machine-specific: hostname, boot, users, keyboard, bluetooth, TLP, fingerprint
  hardware-configuration.nix  # auto-generated — refresh with ./copy-hardware-config.sh
modules/
  nixos/               # system-wide modules
    core.nix             # nix settings, locale, fonts, GC, base CLI packages
    desktop.nix          # GDM, GNOME, pipewire, portals, keyring
    development.nix      # languages, toolchains, language servers, docker/libvirtd
    programs.nix         # desktop apps, editors, AI tools, flake-provided packages
    gaming.nix           # steam, gamemode, graphics, launchers
  home/                # home-manager user modules
    default.nix          # module imports, cursor/gtk theme, xdg dirs, mime defaults
    shell.nix            # zsh, oh-my-zsh, fzf, zoxide, direnv, aliases
    gnome.nix            # dconf settings: extensions, keybinds, scaling, wallpaper
    kitty.nix            # kitty terminal + custom theme (themes/usgc-reticle/)
    opencode.nix         # opencode TUI: USGC-RETICLE theme port (themes/usgc-reticle/) + tui.json selection
    gtk.nix              # GTK theme (WhiteSur-Dark) & font
    git.nix              # git identity
    themes/              # cross-app themes, one dir per theme: themes/<name>/{kitty.conf,opencode.json,...}
.agents/skills/        # agent skill describing this repo's conventions & workflow
rebuild.sh             # helper script: format, diff, rebuild, commit, notify
update.sh              # helper script: update flake inputs and show lock diff
clean.sh               # helper script: remove local artifacts and run nix GC
copy-hardware-config.sh # helper script: refresh hardware-configuration.nix from /etc/nixos
```

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | NixOS unstable channel |
| `home-manager` | User environment management |
| `alejandra` | Nix formatter (`nix fmt`) |
| `helium` | Helium web browser |

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
1. Check for changes (exits early if the tree is clean)
2. Auto-format with alejandra
3. Show a diff
4. Rebuild the system and switch
5. Commit the changes as `Generation $gen`
6. Send a desktop notification on success

### Update flake inputs

```sh
./update.sh                              # updates ALL inputs
nix flake lock --update-input <name>     # update a single input
```

### Clean up local artifacts and Nix store

```sh
./clean.sh
```

## Keybinds (GNOME)

| Key | Action |
|-----|--------|
| `Super + Return` | Open kitty terminal |
| `Super + E` | Open Files (Nautilus) |
| `Super + C` | Close active window |
| `Super + [1-9]` | Switch workspace |
| `Super + Shift + [1-9]` | Move window to workspace |

## Visual Design

```
┌────────────────────────────────────────────────────────────────┐
│ U.S. GRAPHICS COMPANY · RETICLE · DARK SCHEME                  │
│ PN# 5200-020 (SUBLIME) · PN# 5201-010 (ITERM) · KT/OC REV A    │
│ GAMUT: Display P3 → sRGB · FIELD: #000000 · INK: #009D5F       │
└────────────────────────────────────────────────────────────────┘
```

Terminal scheme: **USGC-RETICLE** — a dark scheme derived from a lithography photomask reticle, converted from the Sublime/iTerm source parts for kitty.
Config: `modules/home/themes/usgc-reticle/kitty.conf`.

opencode TUI port: `modules/home/themes/usgc-reticle/opencode.json` — deployed to `~/.config/opencode/themes/` and selected via a declarative `tui.json`, both managed by `modules/home/opencode.nix`. Green stays reserved for default text/nominal state; amber takes the ANSI green slot (strings, headings, list markers); signal colors carry state only.

**Doctrine:** dense, functionalist, utilitarian engineering. Information over whitespace. Instrument green on unlit black; signal colors indicate *state*, never decoration. This scheme rejects modern minimalism and its trends — no pastel palettes, no gradients, no designer whitespace. Every pixel does a job.

### System colors

| REF | FUNCTION | SPEC |
|-----|----------|------|
| FG | Default text (instrument green) | `#009D5F` |
| BG | Field (unlit) | `#000000` |
| SEL | Selection | `#FFC200` on `#000581` |
| CURSOR | Cursor / text under cursor | `#858E97` / `#FFFFFF` |
| URL | Hyperlink underline (hover) | `#00A2B5` |
| BORDER | Active / inactive / bell | `#009D5F` / `#494747` / `#FFC200` |
| TAB-ACT | Active tab | `#000000` on `#009D5F` |
| TAB-INACT | Inactive tab | `#009D5F` on `#262626` |

### ANSI palette (0–15)

| IDX | NAME | NORMAL | BRIGHT |
|-----|------|--------|--------|
| 0/8 | black | `#262626` | `#494747` |
| 1/9 | red | `#E00000` | `#E00000` |
| 2/10 | green | `#FFC200` | `#F4BA00` |
| 3/11 | yellow | `#FFC200` | `#FFC200` |
| 4/12 | blue | `#723DF9` | `#FF7321` |
| 5/13 | magenta | `#FF208F` | `#FF208F` |
| 6/14 | cyan | `#0079FF` | `#0078FF` |
| 7/15 | white | `#FFFFFF` | `#FEFEFF` |

**Nonstandard mappings, by design:** ANSI green (2) is reassigned to amber — the true green is reserved for default text, the way a reticle reserves chrome for the pattern. Bright blue (12) maps to orange `#FF7321` for high-contrast warning legibility. Red and magenta have no bright variant: an alarm state does not get brighter, it gets acknowledged.

> Hex values render as color chips when this file is viewed on GitHub.

## Notable Configurations

- **State versions**: NixOS `24.11`, Home Manager `24.11` — pinned, don't bump without a deliberate migration
- **Home Manager**: runs as a NixOS module, using global pkgs and user packages, with `.hm-backup` file extension for collisions; the nixpkgs release check is disabled (home-manager master against nixos-unstable)
- **Secrets management**: none (no sops-nix/agenix) — secrets are not stored in this repo
- **GPG Agent**: enabled for signing and key management
- **GNOME Keyring**: enabled for secret storage
- **Updates**: weekly `system.autoUpgrade` from the local flake (updates `nixpkgs`/`home-manager` inputs, applies with `switch`, never reboots). It leaves `flake.lock` dirty afterwards — `rebuild.sh` commits it on the next manual run. Manual path remains `./update.sh` + `./rebuild.sh`
- **Firewall**: default NixOS firewall is enabled; LocalSend (TCP/UDP 53317) and Transmission (TCP/UDP 51413) ports are opened explicitly; Steam opens Remote Play ports only (dedicated-server and LAN-transfer ports are closed)
- **Agent skill**: `.agents/skills/nixos-config/` documents repo conventions and the rebuild workflow for coding agents working in this repo
