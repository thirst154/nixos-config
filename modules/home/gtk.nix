{pkgs, ...}: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.adwaita-fonts;
      name = "Adwaita Sans 11";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "WhiteSur";
    };
    gtk3.extraConfig = {
      gtk-hint-font-metrics = 1;
      gtk-enable-animations = true;
    };
    gtk4.extraConfig = {
      gtk-hint-font-metrics = 1;
    };
  };
}
