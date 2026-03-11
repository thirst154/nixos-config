{ pkgs, ... }: {
  imports = [
    ./shell.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./waybar.nix
    ./nvim.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  home.stateVersion = "24.11";
}