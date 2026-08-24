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
  boot.kernelModules = ["i915" "mmc_block"];

  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.kernelParams = ["quiet" "splash" "loglevel=3"];
  boot.consoleLogLevel = 3;

  services.udev.extraRules = ''
    # Disable PCI runtime PM for Genesys GL9750 SD card reader
    SUBSYSTEM=="pci", ATTR{vendor}=="0x17a0", ATTR{device}=="0x9750", ATTR{power/control}="on"
    # Synaptics fingerprint reader
    SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="00bd", MODE="0664", GROUP="plugdev"
  '';

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
  security.pam.services.gdm.fprintAuth = true;

  environment.systemPackages = with pkgs; [
    fprintd
  ];

  users.users.thirst = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "docker" "libvirtd" "plugdev"];
    description = "Thomas Hirst";
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
