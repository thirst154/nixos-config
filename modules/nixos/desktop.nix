{pkgs, ...}: let
  sddm-theme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = ../../assets/sddm-theme;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/custom
      cp -r $src/* $out/share/sddm/themes/custom/
      cp ${../../assets/Wallpaper2.jpg} $out/share/sddm/themes/custom/background.jpg
    '';
  };
in {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${sddm-theme}/share/sddm/themes/custom";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      wl-clipboard
      xdg-utils
      pavucontrol
      networkmanagerapplet

      swaybg
      brightnessctl
      nautilus
    ]
    ++ [sddm-theme];
}
