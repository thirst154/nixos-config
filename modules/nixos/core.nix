{ pkgs, ... }: {
  time.timeZone = "Europe/London";        # change to your TZ
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collect automatically
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  environment.systemPackages = with pkgs; [
    wget curl git ripgrep fd unzip
  ];
}