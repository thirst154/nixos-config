{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user.name = "Thomas Hirst";
    settings.user.email = "thomashirst@pm.me";
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
      };
    };
  };
}
