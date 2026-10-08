# NixOS Config Audit — thinkpad

Date: 2026-09-28
Scope: Full review of the flake for a Go + TypeScript dev laptop with everyday use (email, PDF, documents).
Mode: **Report only** — nothing in the config has been changed.

---

## 1. Executive summary

| # | Severity | Finding | Effort to fix |
|---|----------|---------|---------------|
| S1 | **High** | No disk encryption (root **and** swap are plaintext) | Reinstall / re-image |
| S2 | **High** | `fwupd` not enabled — ThinkPad firmware/BIOS never updated via LVFS | 2 lines |
| S3 | Medium | Steam opens more firewall ports than a laptop needs | 2 lines |
| S4 | Medium | Helium browser depends on a small third-party flake for security patches | Ongoing vigilance |
| S5 | Low | No automatic system updates — patching is fully manual | 4 lines (optional) |
| S6 | Low | `docker` group + `trusted-users` = intentional root-equivalence, undocumented | Comment only |
| P1 | — | No email client (want: Proton Mail Bridge + client) | 2 packages |
| P2 | — | No printing or scanner backend (CUPS/SANE) | 3 lines |
| P3 | — | No password manager (want: Proton Pass) | 1 package |
| P4 | — | Go linting toolchain incomplete | 4 packages |
| P5 | — | No database GUI, no API client | 2 packages |
| Q1 | — | Dead PATH entry `/usr/local/go/bin` (should be `~/go/bin`) | 1 line |
| Q2 | — | `openldap` test-disabling overlay is undocumented | Comment only |

**Status (2026-09-28):** S2, S3, S5, S6, P1–P5, Q1 and Q2 have been **fixed** in the config (verified with `nixos-rebuild build`). Still open: **S1** (disk encryption — needs reinstall) and **S4** (Helium supply-chain vigilance, ongoing).

Details below.

---

## 2. Security findings

### S1 — No full-disk encryption (High)

**Evidence:** `hosts/thinkpad/hardware-configuration.nix` mounts `/` as raw `ext4` directly on a by-uuid device; there is no LUKS (`/dev/mapper/...`) anywhere. Swap is also a raw partition (`nvme0n1p3`, 8.8 GB, confirmed live via `swapon --show`).

**Impact:** This is a laptop. If it's lost or stolen, anyone can boot from USB and read everything: SSH keys, GPG keys, browser sessions, Proton credentials, source code, the GNOME keyring (which is only as strong as the login password, and readable offline), and anything that ever swapped to disk.

**Recommendation:**

- The clean fix is a reinstall with LUKS2 (ideally with TPM2 or FIDO2 unlock — a ThinkPad fingerprint reader can also unlock LUKS via `fprintd` + TPM, though TPM2-totp/systemd-cryptenroll is the common route). This cannot be fixed by editing the flake alone; it needs a re-image. Take a full backup first.
- If a reinstall is not palatable soon, interim mitigations: ensure the GNOME keyring auto-locks on suspend (default), keep the swap usage low, and treat physical access as game-over.
- Optional at reinstall time: Secure Boot via [lanzaboote](https://github.com/nix-community/lanzaboote) for boot-chain integrity.

### S2 — `fwupd` not enabled (High)

**Evidence:** no `services.fwupd` in any module; `systemctl is-enabled fwupd.service` → `not-found`.

**Impact:** ThinkPads get regular firmware updates through LVFS — including security fixes for BIOS/UEFI, Thunderbolt, and the fingerprint reader you rely on. Right now none of them can ever be applied from NixOS.

**Fix (2 lines in `hosts/thinkpad/default.nix`):**

```nix
services.fwupd.enable = true;
```

### S3 — Steam firewall openings are too broad (Medium)

**Evidence:** `modules/nixos/gaming.nix` sets all three of:

```nix
remotePlay.openFirewall = true;            # UDP 27031–27036
dedicatedServer.openFirewall = true;       # TCP/UDP 27015+
localNetworkGameTransfers.openFirewall = true;  # TCP/UDP 27040–27041
```

**Impact:** The default NixOS firewall is enabled (verified live), which is good — but these options punch holes in it on *every* network you join (café Wi-Fi included). Running a dedicated server listener on a laptop is almost never intended.

**Recommendation:** keep `remotePlay` only if you actually stream games; drop `dedicatedServer.openFirewall` and `localNetworkGameTransfers.openFirewall` unless you host LAN games. If you want LAN play occasionally, toggle it per-session instead.

**Related (functional, not security):**

- **LocalSend** is installed as a bare package — its port (TCP/UDP 53317) is closed by the firewall, so receiving files will fail. Prefer the module: `programs.localsend.enable = true; programs.localsend.openFirewall = true;`
- **Transmission** has no inbound port open (51413); downloads still work but swarm connectivity is poor. Open it only if you want better seeding.

### S4 — Helium browser supply-chain risk (Medium)

**Evidence:** `flake.nix` pins `helium` to `github:schembriaiden/helium-browser-nix-flake`; `modules/nixos/programs.nix` patches its flags and it's the default browser (mimeapps in `modules/home/default.nix`).

**Impact:** Your *default browser* — the highest-value attack surface on the machine — comes from a small community flake, not from nixpkgs. Security patches for Chromium land constantly; you're trusting one maintainer's cadence and integrity for all of them. The `follows = "nixpkgs"` wiring is correct, but that only pins the toolchain, not the browser source.

**Recommendation:**

- Check how quickly the flake tracks upstream Helium/Chromium releases; if it lags, treat that as a real exposure.
- Consider a nixpkgs-maintained fallback (Firefox or `ungoogled-chromium`) for banking/sensitive accounts, or as the default if Helium ever falls behind. `tor-browser` is already installed and is also fine as an isolated secondary.

### S5 — No automatic system updates (Low)

**Evidence:** no `system.autoUpgrade` anywhere; updates are manual via `./update.sh` + `./rebuild.sh`.

**Impact:** nixos-unstable moves fast; gaps between manual updates mean running with known-vulnerable packages. This is a common and defensible choice (you review diffs), but be aware of the tradeoff.

**Options:** keep manual but set a weekly habit; or `system.autoUpgrade.enable = true; system.autoUpgrade.flake = "github:you/nixos-config";` with `allowReboot = false`. Given the generation-per-commit workflow in `rebuild.sh`, manual-with-habit fits this repo best.

### S6 — Intentional root-equivalence, undocumented (Low)

**Evidence:**

- `users.users.thirst.extraGroups` includes `docker` (`hosts/thinkpad/default.nix`) — anyone in this group is effectively root (`docker run -v /:/host ...`).
- `nix.settings.trusted-users = ["root" "thirst"]` (`modules/nixos/core.nix`) — lets your user add binary-cache substituters and (combined with other nix options) escalate.

**Impact:** Standard, sensible choices for a single-user dev box, but they mean *any* process running as `thirst` (a malicious `npm postinstall`, a compromised dev dependency) is one command away from root.

**Recommendation:** no change needed — add a comment in each file noting it's a deliberate tradeoff. If you ever want to reduce it, rootless docker or `podman` with `dockerCompat` is the path.

### Minor security notes

- **Git commit signing:** `programs.gnupg.agent.enable = true` but `modules/home/git.nix` has no `signing` config. For a dev machine pushing to GitHub, signing commits (GPG or SSH — GitHub accepts SSH signing and you likely have a key already) is a cheap win.
- **Screen lock:** no explicit dconf lock settings; GNOME defaults (blank + lock) apply. Consider pinning them in `modules/home/gnome.nix` (`org/gnome/desktop/session` `idle-delay`, `org/gnome/desktop/screensaver` `lock-enabled`) so a GNOME default change can't silently weaken it.
- **`openldap` overlay** (`modules/nixos/core.nix`) disables the package's test suite with no comment. It's presumably a build-failure workaround — document why, with the error it avoids, so future-you knows when it's safe to delete.
- **SSH server:** not enabled — good, no action.
- **Firewall default:** enabled (verified live) — good.

---

## 3. Missing packages & features

Filtered by your answers: email = Proton Bridge + client; office = web-only; extras = printing/scanning + Proton Pass; dev = Go linting, DB GUI, API client.

### Everyday

| Want | Recommendation | Notes |
|------|----------------|-------|
| Proton Mail | `protonmail-bridge` + `thunderbird` | Bridge is the officially supported IMAP/SMTP bridge; **Thunderbird is the client Proton documents and tests against** (Geary works but is fiddly with Bridge's local certs). Put both in `modules/nixos/programs.nix`; Bridge runs as a user service — start it once via `systemctl --user` or just launch it and let it autostart. |
| Passwords | `proton-pass` | Desktop app exists in your pinned nixpkgs (v1.40.2). Browser extension inside Helium is also worth having. |
| Printing | `services.printing.enable = true;` + `services.avahi.enable = true; services.avahi.nssmdns4 = true;` | CUPS + mDNS = driverless discovery of network printers. Add `services.ipp-usb.enable = true;` for modern USB printers. |
| Scanning | `hardware.sane.enable = true;` | `simple-scan` is **already installed** (verified on the live system) but useless without the SANE backend. Add `sane-backends` support and the user is already in the right groups. |
| PDF | — | **Covered already**: `papers` (GNOME's document viewer) is installed via GNOME core utilities. No action needed. |
| Office docs | — | Per your choice: web-only. Note that `.docx`/`.xlsx` attachments can't be previewed offline without a suite — Nautilus will offer "open in browser". If that ever annoys you, `libreoffice-fresh` is one line. |

### Dev (Go + TS)

| Gap | Recommendation | Notes |
|-----|----------------|-------|
| Go linting | `golangci-lint`, `gotools`, `gomodifytags`, `impl`, `gosec` | You have `gopls`/`gofumpt`/`delve` but no linter — `golangci-lint` is the de-facto standard and most Go repos' CI runs it. `gotools` gives `goimports` etc.; `gomodifytags`/`impl` are the editor helpers gopls shells out to. All confirmed present in your pinned nixpkgs. → `modules/nixos/development.nix` |
| Database GUI | `dbeaver-bin` | Universal (Postgres/MySQL/SQLite/…). `beekeeper-studio` is the lighter alternative. |
| API client | `bruno` | Offline, stores collections as files in your repo (git-friendly). `insomnia` if you prefer the classic GUI. Both in nixpkgs. |

**Worth knowing about even though you didn't pick them** (they plug real gaps in the TS setup):

- `vscode-langservers-extracted` — you have LSPs for a dozen languages but **no eslint/css/html/json language servers**, the bread-and-butter TS ones. `typescript-language-server` alone doesn't lint.
- `docker-compose` — docker is enabled but there's no `docker compose` binary; almost every Go/TS repo with a compose file needs it.
- `programs.nix-ld.enable = true;` — lets unpatched prebuilt binaries (some npm native tools, downloaded linters, vendor CLIs) run on NixOS. A classic day-2 pain point.

### Workflow suggestion

You already have `direnv` + `nix-direnv`. The idiomatic NixOS setup is **per-project dev shells** (`shell.nix`/`flake.nix` with `mkShell` per repo, auto-loaded by direnv) instead of one global pile of toolchains. Benefits: Go 1.x for one client, Node 20 vs 22 across projects, no version clashes. No rush — but as the global list in `development.nix` grows (it's already 8 toolchains), it starts to bite.

---

## 4. Config improvements & hygiene

1. **Dead PATH entry** — `modules/home/shell.nix` adds `/usr/local/go/bin` to `home.sessionPath`. That path does not exist on NixOS (Go lives in the nix store). What you almost certainly want is `$HOME/go/bin`, which is where `go install` drops binaries:
   ```nix
   home.sessionPath = [ "$HOME/.opencode/bin" "$HOME/.local/bin" "$HOME/go/bin" ];
   ```
   Without this, anything you `go install` (including tools recommended above) is invisible to your shell.

2. **Add `thermald`** — `services.thermald.enable = true;` in `hosts/thinkpad/default.nix`. Intel thermal daemon prevents the CPU from cooking itself before firmware throttling kicks in; standard on ThinkPads alongside TLP (no conflict).

3. **Editor bloat** — `programs.nix` installs five editors: vscode, neovim, neovide, emacs, kakoune, zed-editor. Harmless but each pulls big dependency trees into every generation and slows rebuilds. Consider keeping the two you actually use.

4. **Three JDKs** (8/17/21) for Minecraft launchers — fine if you play those versions; otherwise `jdk21` alone covers modern launchers. Store cost only.

5. **Undocumented overlays** — both overlays (`openldap` test skip, `gnome-control-center` libfprint) lack comments. One line each ("why this exists / when to remove") saves real time later.

6. **README drift check** — README is currently accurate (firewall note re: localsend/transmission is correct — and this audit agrees it's an issue, see S3). If you apply changes from this audit, update the Features/Notable sections to match.

7. **Minor:** `environment.variables.EDITOR` in `programs.nix` — works, but `environment.sessionVariables` (or HM's `home.sessionVariables.EDITOR`) is the more idiomatic home for it. Cosmetic.

---

## 5. What's already good

- Firewall enabled by default; no SSH server; polkit + keyring wired correctly; PAM fingerprint limited to sudo/GDM.
- Boot hardening details done right: `/boot` mounted `fmask=0077,dmask=0077`, grub generation limit, microcode updates via `enableRedistributableFirmware`.
- TLP correctly configured with `power-profiles-daemon` explicitly disabled (they conflict — a very common mistake, avoided).
- Weekly GC + nightly store optimise + 10-generation boot limit: sane disk hygiene.
- `home-manager.backupFileExtension` set, state versions deliberately pinned, one `nixpkgs` in the closure via `follows`.
- GNOME stack is complete: pipewire with wireplumber, portals, gvfs, thumbnails, and core utilities (papers, simple-scan, calculator) all present.

---

## 6. Suggested next steps (in order)

1. **Now (pure config, zero risk):** fwupd, thermald, CUPS+avahi+SANE, LocalSend module with `openFirewall`, fix `~/go/bin` PATH, Proton Pass, Proton Mail Bridge + Thunderbird, Go linting packages, dbeaver-bin, bruno, docker-compose, vscode-langservers-extracted.
2. **This week:** tighten Steam firewall options; decide on Helium's update cadence; set up git commit signing.
3. **Planned maintenance window:** backup → reinstall with LUKS2 (consider lanzaboote for Secure Boot at the same time).

Say the word and I'll apply step 1 (and any of step 2 you approve) following the repo's edit → format → `./rebuild.sh` workflow.
