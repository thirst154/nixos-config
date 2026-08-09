{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./shell.nix
    ./kitty.nix
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
    enable = true;
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
    setSessionVariables = true;
  };

  home.sessionVariables = {
    XDG_DATA_DIRS = "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}:\${XDG_DATA_DIRS}";
  };

  home.stateVersion = "24.11";
  wayland.windowManager.hyprland.configType = "hyprlang";
}
