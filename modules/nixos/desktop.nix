{pkgs, ...}: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland.enable = true;

  services.libinput.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    wl-clipboard
    xdg-utils
    pavucontrol
    networkmanagerapplet
    # Firefox

    # Hyprland
    kitty
    waybar
    mako
    wofi
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
  ];
}
