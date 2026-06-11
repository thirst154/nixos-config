{
  pkgs,
  inputs,
  ...
}: {
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xdg-utils
    pavucontrol
    networkmanagerapplet

    swaybg
    brightnessctl
    nautilus
  ];
}
