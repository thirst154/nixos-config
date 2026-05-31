{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./hyprland.nix
    ./mako.nix
    ./wofi.nix
    ./waybar.nix
    ./hyprlock.nix
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

  home.stateVersion = "26.05";
  wayland.windowManager.hyprland.configType = "hyprlang";
}
