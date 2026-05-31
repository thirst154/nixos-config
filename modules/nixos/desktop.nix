{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  programs.hyprland.enable = true;

  services.libinput.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  #environment.gnome.excludePackages = with pkgs; [
  #  gnome-tour
  #  epiphany
  #  geary
  #];

  environment.systemPackages = with pkgs; [
    #gnome-tweaks
    #gnome-extension-manager
    wl-clipboard
    xdg-utils
    pavucontrol
    networkmanagerapplet
    # Firefox

    #  Hyprland
    kitty
    waybar
    mako
    swaybg
    brightnessctl

    # Greeter theming
    papirus-icon-theme
    bibata-cursors
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  xdg.portal.config = {
    common.default = ["gtk"];
    hyprland."org.freedesktop.impl.portal.ScreenCast" = "hyprland";
    hyprland."org.freedesktop.impl.portal.Screenshot" = "hyprland";
  };

  services.gnome.gnome-keyring.enable = true;

  environment.etc."greetd/regreet.toml".text = ''
    [background]
    path = "${./../../assets/Wallpaper.jpeg}"
    fit = "Cover"

    [GTK]
    application_prefer_dark_theme = true
    icon_theme_name = "Papirus-Dark"
    cursor_theme_name = "Bibata-Modern-Classic"
  '';
}
