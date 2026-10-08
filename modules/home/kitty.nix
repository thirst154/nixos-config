{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
    };

    # Custom USGC-RETICLE theme (converted from the iTerm/sublime usgc-themes)
    extraConfig = "include themes/USGC-RETICLE-KT.conf";
  };

  xdg.configFile."kitty/themes/USGC-RETICLE-KT.conf".source =
    ./themes/usgc-reticle/kitty.conf;
}
