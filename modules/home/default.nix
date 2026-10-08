{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./shell.nix
    ./git.nix
    ./gtk.nix
    ./gnome.nix
    ./kitty.nix
    ./opencode.nix
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
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur";
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "helium.desktop";
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
    "x-www-browser" = "helium.desktop";
  };

  home.sessionVariables = {
    XDG_DATA_DIRS = "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}:\${XDG_DATA_DIRS}";
  };

  home.stateVersion = "24.11";
}
