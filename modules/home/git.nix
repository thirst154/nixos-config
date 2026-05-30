{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user.name = "Thomas Hirst";
    settings.user.email = "thomashirst@pm.me";
  };
}
