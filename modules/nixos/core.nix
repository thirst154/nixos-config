{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    # openldap's test suite fails in the nix build sandbox; skip tests so it builds.
    # Workaround only — try removing after nixpkgs bumps.
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # trusted-users can set binary caches and other privileged nix options —
    # effectively root-equivalent. Deliberate tradeoff on a single-user dev box.
    trusted-users = ["root" "thirst"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = ["03:45"];

  # Weekly auto-upgrade: updates nixpkgs/home-manager inputs and applies with
  # `switch` (never reboots). Uses the tracked state of the local flake; leaves
  # flake.lock dirty afterwards — rebuild.sh commits it on the next manual run.
  system.autoUpgrade = {
    enable = true;
    flake = "/home/thirst/nixos-config";
    flags = ["--update-input" "nixpkgs" "--update-input" "home-manager"];
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    ripgrep
    fd
    unzip
    btop
    fzf
    zoxide
    eza
    fortune
    cowsay
    fastfetch
    vim
  ];
}
