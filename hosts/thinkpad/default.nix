{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix          # stays off git
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/programs.nix
  ];

  networking.hostName = "thinkpad";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  programs.zsh.enable = true;

  # Your user account
  users.users.thirst = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;         # zsh set at system level too
  };

  system.stateVersion = "24.11";
}
