{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "thirst"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = ["03:45"];

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
