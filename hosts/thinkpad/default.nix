{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/programs.nix
  ];

  networking.hostName = "thinkpad";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  users.users.thirst = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
