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
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  hardware.enableRedistributableFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  programs.zsh.enable = true;
  programs.gnupg.agent.enable = true;

  users.users.thirst = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "docker"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
