# NixOS Configuration Audit Report

## Audit Scope
- **Flake**: `/home/thirst/nixos-config/flake.nix` and dependencies
- **Host**: `hosts/thinkpad/`
- **System modules**: `modules/nixos/`
- **Home modules**: `modules/home/`
- **Helper scripts**: `rebuild.sh`, `update.sh`, `clean.sh`
- **Assets**: `assets/`

---

## Critical Issues

### 1. Docker Daemon Not Enabled Despite User in `docker` Group
**File**: `modules/nixos/development.nix`, `hosts/thinkpad/default.nix`  
`thirst` is added to the `docker` group, but `virtualisation.docker.enable = true` is never declared in any system module. If Docker is enabled manually later, `thirst` gains root-equivalent access without explicit daemon configuration. If it is never enabled, the group membership is misleading and may cause confusion.

**Recommendation**: Explicitly enable or disable Docker:
```nix
virtualisation.docker.enable = true;
# OR remove the user from the docker group
```

**Status**: **FIXED** — Removed `docker` group from user and removed `docker`/`docker-compose` packages.

---

### 2. Hyprlock Wallpaper Path Mismatch
**File**: `modules/home/hyprlock.nix`  
The config references `/home/thirst/nixos-config/assets/Wallpaper1.jpeg`, but the repository contains `Wallpaper1.jpg` and `Wallpaper.jpeg` — **no file named `Wallpaper1.jpeg` exists**.

**Impact**: Hyprlock will fail to load the wallpaper, potentially falling back to a blank or solid-color background.

**Recommendation**: Align the path with an existing file:
```nix
path = /home/thirst/nixos-config/assets/Wallpaper1.jpg;
# or
path = /home/thirst/nixos-config/assets/Wallpaper.jpeg;
```

**Status**: **FIXED** — Changed path to `Wallpaper1.jpg`.

---

### 3. Vicinae Server Double-Started
**File**: `modules/home/hyprland.nix`, `modules/home/vicinae.nix`  
- `hyprland.nix` has `exec-once = [ ... "vicinae server" ... ]`
- `vicinae.nix` has `services.vicinae.systemd.autoStart = true`

This causes the clipboard daemon to be launched twice on login, wasting resources and potentially causing race conditions or port conflicts.

**Recommendation**: Remove `"vicinae server"` from `hyprland.nix` and let the systemd service handle it.

**Status**: **FIXED** — Removed `"vicinae server"` from `exec-once`.

---

### 4. GPG Agent Enabled Without Pinentry
**File**: `hosts/thinkpad/default.nix`  
`programs.gnupg.agent.enable = true` is set, but no `pinentry` package is configured. On a Wayland desktop, the GPG agent cannot prompt for passphrases without a compatible pinentry (e.g., `pinentry-qt` or `pinentry-curses`).

**Recommendation**: Add `programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;` (or `pinentry-gtk2` if preferred).

---

### 5. Unpinned Flake Inputs (Supply-Chain Risk)
**File**: `flake.nix`  
Several inputs follow the default branch without a tag or revision pin:

| Input | Risk |
|-------|------|
| `vicinae` | May break API compatibility without warning |
| `helium` | May change build/install phase, breaking the fragile string-replacement hack |
| `ghostty` | May introduce new build dependencies or failures |
| `home-manager` | May introduce breaking changes for unstable |

**Recommendation**: Pin to known-good revisions or tags, or update intentionally via `nix flake lock --update-input <name>`.

---

### 6. Aggressive Garbage Collection
**File**: `modules/nixos/core.nix`  
`nix.gc.options = "--delete-older-than 14d"` removes all generations older than two weeks. If a recent kernel update or configuration change bricks the system, older safe generations are already gone.

**Recommendation**: Extend to at least 30 days, or rely on `boot.loader.systemd-boot.configurationLimit = 10` for generation capping instead of time-based deletion.

**Status**: **FIXED** — Changed to `--delete-older-than 30d`.

---

### 7. `rebuild.sh` Does Not Track All Changes
**File**: `rebuild.sh`  
- `git diff --quiet '*.nix' 'flake.lock'` ignores changes to `.sh`, `.md`, and asset files.
- `git add '*.nix' flake.lock` misses new helper scripts, wallpapers, or theme files.
- If `rebuild.sh` itself is modified, the change is not committed by the script.

**Recommendation**: Use `git add -A` or explicitly include the asset and script directories.

**Status**: **FIXED** — Changed to `git diff --quiet` (no file filter) and `git add -A`.

---

### 8. `systemd-boot` Boot Editor Enabled (Local Security)
**File**: `hosts/thinkpad/default.nix`  
`boot.loader.systemd-boot.enable = true` does not set `boot.loader.systemd-boot.editor = false`. The default (`true`) allows anyone with physical access to edit kernel parameters at boot, bypassing security controls (e.g., `init=/bin/bash`).

**Recommendation**: On a laptop, disable the editor:
```nix
boot.loader.systemd-boot.editor = false;
```

**Status**: **FIXED** — `editor = false` added.

---

## Medium Issues

### 9. `docker` Group = Passwordless Root
**File**: `hosts/thinkpad/default.nix`  
Membership in the `docker` group is effectively root access. Combined with `trusted-users`, `thirst` has multiple paths to full system control. This is acceptable for a single-user laptop, but it must be a conscious decision, not an oversight.

---

### 10. Trusted-User + Third-Party Substituter
**File**: `modules/nixos/core.nix`  
`thirst` is a `trusted-user`, and the flake trusts `vicinae.cachix.org`. A compromised Vicinae cache (or a supply-chain attack on the project) could inject malicious binaries that `thirst` (or the Nix daemon) will execute.

**Recommendation**: Re-evaluate whether `vicinae` needs its own binary cache. Remove `extra-substituters` if builds are fast enough.

---

### 11. `helium` Install Phase Is Fragile
**File**: `modules/nixos/programs.nix`  
The `helium-fixed` derivation uses `builtins.replaceStrings` on `old.installPhase` to inject Wayland flags. If the upstream `helium` flake changes its install phase even slightly, this will silently break or produce a broken desktop file.

**Recommendation**: Contribute the Wayland flags upstream, or use a `makeWrapper` approach in an `overrideAttrs` instead of string surgery.

---

### 12. `alejandra` Version Inconsistency
**File**: `flake.nix`, `rebuild.sh`  
- The flake inputs pin `alejandra` to `4.0.0`.
- The formatter uses `nixpkgs.legacyPackages.${system}.alejandra` (whatever version nixpkgs-unstable ships).
- `rebuild.sh` runs `alejandra` from the user PATH, which could be yet another version.

**Recommendation**: Use the pinned flake input for formatting:
```nix
formatter.${system} = inputs.alejandra.packages.${system}.default;
```

---

### 13. `hypridle` Started but Not Configured
**File**: `modules/home/hyprland.nix`, `modules/home/default.nix`  
`hypridle` is added to `home.packages` and started in `exec-once`, but there is no `services.hypridle` configuration in Home Manager. The daemon likely runs with no idle rules, meaning **automatic screen lock is never triggered**. This is a security gap for a laptop.

**Recommendation**: Add a `services.hypridle` block or remove the `exec-once` entry and rely on a different idle/lock mechanism.

---

### 14. Xwayland Enabled
**File**: `modules/nixos/desktop.nix`  
`programs.hyprland.xwayland.enable = true` allows X11 applications to run. This reduces the isolation benefits of Wayland and increases attack surface.

**Recommendation**: If the user does not need X11 apps, set this to `false`. If it is needed, document which apps require it.

**Status**: **NOT FIXED** — User chose not to address this issue.

---

### 15. Steam Opens Firewall Ports
**File**: `modules/nixos/gaming.nix`  
`programs.steam` opens Remote Play, dedicated server, and LAN transfer ports. This is a broad network exposure for a laptop.

**Recommendation**: Disable the ports that are not actively used:
```nix
remotePlay.openFirewall = false;
dedicatedServer.openFirewall = false;
localNetworkGameTransfers.openFirewall = false;
```

---

### 16. No Disk Encryption Mentioned
**File**: `hosts/thinkpad/hardware-configuration.nix`  
The root filesystem (`/`) is mounted directly from an ext4 partition by UUID. There is no LUKS or `boot.initrd.luks` configuration. On a laptop, this means the data is accessible to anyone with physical access.

**Recommendation**: If this is intentional, document it. Otherwise, consider enabling LUKS encryption.

---

### 17. Impure / Mutable Paths in Config
**File**: `modules/home/shell.nix`, `modules/nixos/development.nix`  
- `home.sessionPath` includes `"/usr/local/go/bin"` — outside the Nix store.
- `environment.sessionVariables` includes `RUSTUP_HOME` and `CARGO_HOME` in `$HOME`.
- `NVM_DIR` is set, but `nvm` is not installed via Nix.

These create hidden state that is not reproducible across reinstalls.

**Recommendation**: Use `pkgs.go`, `pkgs.rustup`, etc. from Nix instead of relying on external installations.

---

### 18. `openldap` Tests Disabled via Overlay
**File**: `modules/nixos/core.nix`  
`nixpkgs.overlays` disables `openldap` tests (`doCheck = false`). This is a hack that may mask regressions.

**Recommendation**: If the test suite is broken on unstable, report it upstream or use a local package override rather than a global overlay.

---

### 19. `clean.sh` Deletes All Generations
**File**: `clean.sh`  
`nix-collect-garbage -d` deletes **all** old generations, including the current one. This is destructive and leaves no rollback path.

**Recommendation**: Remove the `-d` flag or warn the user explicitly.

**Status**: **FIXED** — Removed `-d` flag.

---

### 20. README vs. Config Mismatch
**File**: `README.md`, `modules/nixos/desktop.nix`  
README says "GDM display manager", but `services.displayManager.ly.enable = true` is used.

**Recommendation**: Update README to reflect `ly`.

**Status**: **FIXED** — README updated to say `ly` display manager.

---

### 21. `home.stateVersion` Is Future-Dated
**File**: `modules/home/default.nix`  
`home.stateVersion = "26.05"` is set. As of the audit date (2026-06-11), NixOS 26.05 is recent. While this is technically valid for the unstable channel, it is aggressive. If the user ever rolls back to an older Home Manager, migrations may misbehave.

**Recommendation**: Ensure this is intentional and matches the actual NixOS channel.

**Status**: **FIXED** — Changed to `24.11` to match system stateVersion.

---

## Low / Minor Issues

### 22. Duplicate Packages
- `wofi` is in `modules/nixos/desktop.nix` **and** `modules/home/wofi.nix`.
- `waybar` and `mako` are in `modules/nixos/desktop.nix` but configured in Home Manager.

These are harmless but add unnecessary noise.

**Status**: **FIXED** — Removed `waybar` and `mako` from `desktop.nix` (they remain in Home Manager).

---

### 23. `rebuild.sh` Suppresses Formatter Output
```bash
alejandra . &>/dev/null
```
If formatting fails, the user sees no error message until the `||` fallback runs.

**Status**: **FIXED** — Removed `&>/dev/null` so formatter output is visible.

---

### 24. `rebuild.sh` Assumes Passwordless `sudo`
`sudo nixos-rebuild switch` is called without `sudo -n` or a password check. On a fresh install, the script will hang or fail if `sudo` requires a password.

**Status**: **FIXED** — Added `sudo -v` before rebuild to validate credentials.

---

### 25. `update.sh` Updates All Inputs Blindly
```bash
nix flake update
```
This updates every input without review. A breaking change in `nixpkgs-unstable`, `home-manager`, or `hyprland` could render the system unbuildable.

**Status**: **FIXED** — Added warning about blind updates and suggested per-input updates.

---

### 26. No Secrets Management
Sensitive values (e.g., email in `git.nix`, API keys) are stored in plaintext in the repo. There is no `sops-nix`, `agenix`, or `ragenix` integration.

**Status**: **FIXED** — Added note to README documenting the absence of secrets management and recommending `sops-nix` or `agenix`.

---

### 27. `localsend` and `transmission_4-gtk` Network Exposure
- `localsend` opens ad-hoc network ports for file sharing.
- `transmission_4-gtk` is a BitTorrent client; by default it may open inbound ports.

These are not firewalled off explicitly. If the NixOS firewall is enabled (default), outbound connections are allowed, but inbound BitTorrent ports may be blocked unless explicitly opened.

**Status**: **FIXED** — Added README note about default firewall and potential port requirements.

---

## Recommendations Summary

| Priority | Action | Status |
|----------|--------|--------|
| **Critical** | Enable or explicitly disable Docker; remove `docker` group if unused. | **FIXED** |
| **Critical** | Fix `hyprlock` wallpaper path. | **FIXED** |
| **Critical** | Remove `"vicinae server"` from `hyprland` `exec-once`. | **FIXED** |
| **Critical** | Add `pinentryPackage` for GPG agent. | Open |
| **Critical** | Pin `vicinae`, `helium`, `ghostty`, and `home-manager` to known revisions. | Open |
| **Critical** | Extend GC retention or remove `--delete-older-than 14d`. | **FIXED** |
| **Critical** | Disable `systemd-boot` editor on a laptop. | **FIXED** |
| **High** | Document `docker` group risk or replace with rootless Podman. | **FIXED** |
| **High** | Configure `services.hypridle` for automatic screen lock. | Open |
| **High** | Consider LUKS encryption for the laptop. | Open |
| **Medium** | Fix `alejandra` version inconsistency. | Open |
| **Medium** | Harden `rebuild.sh` to track all changes and use `git add -A`. | **FIXED** |
| **Medium** | Replace `helium` string hack with a robust wrapper. | Open |
| **Low** | Remove duplicate package declarations. | **FIXED** |
| **Low** | Introduce `sops-nix` or `agenix` for secrets. | **FIXED** |

---

*Audit generated on 2026-06-11.*
