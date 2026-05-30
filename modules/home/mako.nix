{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      font = "JetBrainsMonoNL Nerd Font 12";
      background-color = "#1E1E1EF2";
      text-color = "#FFFFFF";
      border-color = "#FFFFFF1A";
      border-size = 1;
      border-radius = 4;
      padding = "12";
      width = 350;
      max-visible = 5;
      default-timeout = 5000;
      icons = 1;
    };
  };
}
