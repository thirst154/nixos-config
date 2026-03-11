{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix          # stays off git
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/programs.nix
  ];

  networking.hostName = "thinkpad";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";   # adjust if your VM disk is vda, nvme0n1, etc.
  };

  programs.zsh.enable = true;

  # Your user account
  users.users.thirst = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;         # zsh set at system level too
  };

  system.stateVersion = "24.11";
}