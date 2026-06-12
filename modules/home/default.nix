{
  config,
  pkgs,
  ...
}: {
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
    ./vicinae.nix
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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.stateVersion = "24.11";
  wayland.windowManager.hyprland.configType = "hyprlang";
}
