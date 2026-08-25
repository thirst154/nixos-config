{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.whitesur-gtk-theme;
      name = "WhiteSur-Dark";
    };
    font = {
      package = pkgs.adwaita-fonts;
      name = "Adwaita Sans 11";
    };
    gtk3.extraConfig = {
      gtk-enable-animations = true;
    };
    gtk4.extraConfig = {
      gtk-hint-font-metrics = 1;
    };
  };
}
