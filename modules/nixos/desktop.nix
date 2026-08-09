{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.polkit.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xdg-utils
    pavucontrol
    networkmanagerapplet

    swaybg
    brightnessctl
    nautilus

    grim
    slurp
    swappy
  ];
}
