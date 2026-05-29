{pkgs, ...}: {
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  networking.networkmanager.enable = true;

  services.displayManager.ly.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # WM / Desktop
    swww
    waybar
    hyprlock
    hypridle
    mako
    ghostty
    kitty

    # System utilities
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
    pavucontrol
    networkmanagerapplet

    # Apps
    nautilus
    bibata-cursors
    papirus-icon-theme
  ];
}
