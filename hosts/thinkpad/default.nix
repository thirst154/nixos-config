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

  boot.initrd.kernelModules = ["i915"];
  boot.kernelModules = ["i915"];

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  programs.zsh.enable = true;
  programs.gnupg.agent.enable = true;

  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sddm.fprintAuth = true;

  users.users.thirst = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
