---
name: nixos-config
description: Conventions and workflow for this NixOS flake config repo (hosts/thinkpad + modules/nixos + modules/home, Home Manager as a NixOS module, alejandra formatting, rebuild.sh). Use this skill whenever the user asks to add or remove packages, change system or Home Manager settings, create or edit .nix modules, add a GNOME extension or dconf setting, add a flake input, update flake.lock, or rebuild/switch the NixOS system in this repo — even for small requests like "install X", "tweak my config", or "rebuild my system".
---

# Working in this NixOS config repo

This repo is the single NixOS flake for one machine. Getting a change right here means putting it in the right module, formatting it, and letting the rebuild script handle the commit — the repo has strong conventions for all three.

## Repo at a glance

- One host: `thinkpad` (ThinkPad laptop, Intel i915, fingerprint reader, TLP)
- One user: `thirst`
- `nixos-unstable` channel; **NixOS and Home Manager state versions are both pinned to `24.11`** — don't bump these unless the user explicitly asks for a migration
- Home Manager runs **as a NixOS module**, not standalone. User config lives in `modules/home/` and is wired up in `flake.nix` via `home-manager.users.thirst`
- Desktop: **GNOME** (GDM) with user-level GNOME config via `dconf.settings` in `modules/home/gnome.nix`. Terminal: **kitty**
- `nixpkgs.config.allowUnfree = true` is already set globally

## Layout

```
flake.nix                     # inputs, outputs, formatter (alejandra), home-manager wiring
hosts/thinkpad/
  default.nix                 # machine-specific: hostname, boot, users, keyboard, bluetooth, TLP, fingerprint
  hardware-configuration.nix  # AUTO-GENERATED — see "Pitfalls"
modules/nixos/                # system-wide modules, imported by hosts/thinkpad/default.nix
  core.nix                    # nix settings, locale, fonts, GC, base CLI packages
  desktop.nix                 # GDM, GNOME, pipewire, portals, keyring
  development.nix             # languages, toolchains, language servers
  programs.nix                # desktop apps, editors, AI tools, flake-provided packages
  gaming.nix                  # steam, gamemode, graphics, launchers
modules/home/                 # Home Manager modules, imported by modules/home/default.nix
  default.nix                 # imports + cursor/gtk theme, xdg dirs, mime defaults
  shell.nix                   # zsh, oh-my-zsh, fzf, zoxide, direnv, aliases
  gnome.nix                   # dconf settings: extensions, keybinds, scaling, wallpaper
  git.nix / gtk.nix / kitty.nix / opencode.nix  # opencode.nix: USGC-RETICLE TUI theme + tui.json
  themes/<name>/              # cross-app theme dirs — one file per app (kitty.conf, opencode.json, ...)
assets/                       # wallpapers, themes (referenced by absolute path in dconf settings)
rebuild.sh / update.sh / clean.sh / copy-hardware-config.sh
```

## Where does a change go?

- **System service, boot, kernel, hardware, networking, user account** → `hosts/thinkpad/default.nix` if it's truly machine-specific, otherwise the themed file in `modules/nixos/`
- **New system package** → pick the themed `modules/nixos/` file it belongs to (base CLI tool → `core.nix`, dev tool/language/LSP → `development.nix`, desktop app/editor → `programs.nix`, game-related → `gaming.nix`). Packages go in `environment.systemPackages = with pkgs; [ ... ]`, keeping the existing section comments
- **User application config, shell, dotfiles, GNOME settings** → `modules/home/`, preferring Home Manager's `programs.*` options when they exist (see `kitty.nix`, `shell.nix`, `git.nix` for the pattern)
- **GNOME extension or GNOME setting** → `modules/home/gnome.nix`: add the package to `home.packages`, its ID to `enabled-extensions`, and settings under `dconf.settings`
- **New module file** → create it in the right directory, then register it in the `imports` list of `modules/home/default.nix` (home) or `hosts/thinkpad/default.nix` (system). A module that isn't imported does nothing

## Conventions

- Module shape is a plain function returning an attrset: `{pkgs, ...}: { ... }` — add `inputs` to the args only when the module needs a flake input
- `inputs` is available in all modules via `specialArgs` (NixOS) and `extraSpecialArgs` (Home Manager) — don't thread it through manually
- Formatting is **alejandra** (2-space indent, the style you see in every file). Run `alejandra .` or `nix fmt` after editing — `rebuild.sh` also formats, but format before showing the user a diff so they review the final form
- To use a package from a flake input, follow the `helium` pattern in `modules/nixos/programs.nix`: bind it in a `let` as `inputs.<name>.packages.${pkgs.stdenv.hostPlatform.system}.default`, then reference it in the package list
- Adding a new flake input: declare it in `flake.nix` with `inputs.nixpkgs.follows = "nixpkgs"` (keeps one nixpkgs in the closure), add it to the `outputs` argument list, then use it via `inputs`

## Workflow: edit → format → rebuild

1. Edit the relevant module(s)
2. Format: `alejandra .` (or `nix fmt`)
3. Optional fast sanity check without switching: `nixos-rebuild build --flake .#thinkpad` (no sudo needed, builds to a `result` symlink)
4. Apply with `./rebuild.sh` — it formats, shows the diff, runs `sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad`, and commits. Build output goes to `nixos-switch.log`; on failure it prints the error lines. Note it exits early with "No changes detected" if the tree is clean
5. `sudo` is required for `switch` — ask the user to run it or expect a password prompt; don't try to work around sudo

## Git: let rebuild.sh commit

Every commit in this repo's history is `Generation $gen`, made by `rebuild.sh` after a successful switch. So:

- **Don't manually `git commit` config changes** unless the user asks — the rebuild script is the commit path, and committing separately breaks the generation-per-commit pattern
- Warn the user if there are unrelated dirty files before running `rebuild.sh`: it does `git add -A` and will sweep everything into the generation commit

## Pitfalls

- **Never edit `hosts/thinkpad/hardware-configuration.nix` by hand.** It's auto-generated; `./copy-hardware-config.sh` refreshes it from `/etc/nixos/hardware-configuration.nix` after hardware changes
- **`update.sh` updates ALL flake inputs blindly.** To update one input, use `nix flake lock --update-input <name>` instead
- **README.md can drift** — it once described a Hyprland/Ghostty setup long after the config moved to GNOME/kitty. Treat the `.nix` files as the source of truth, and offer to update the README when your changes alter what it documents
- `assets/` is referenced by absolute path (`file:///home/thirst/nixos-config/assets/...`) in dconf settings — moving the repo or the assets breaks wallpaper/theme references
- `home-manager.backupFileExtension = "hm-backup"` is set: if Home Manager complains about an existing file, the user has a dotfile outside nix that needs deleting or adopting, not a config bug
- Don't disable `home.enableNixpkgsReleaseCheck = false` fallout by "fixing" version mismatches — the check is intentionally off because home-manager tracks master against nixos-unstable
- `system.autoUpgrade` runs weekly and updates the `nixpkgs`/`home-manager` inputs, leaving `flake.lock` dirty — that's expected, not a problem; `rebuild.sh` commits the lock change on the next manual run

## Helper scripts

| Script | Purpose |
|--------|---------|
| `./rebuild.sh` | format → diff → switch → commit as `Generation $gen` → notify |
| `./update.sh` | `nix flake update` (all inputs) + show lock diff |
| `./clean.sh` | remove `result/`, `nixos-switch.log`, run `nix-collect-garbage` |
| `./copy-hardware-config.sh` | re-copy hardware-configuration.nix from `/etc/nixos` |
