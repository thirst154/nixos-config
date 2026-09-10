{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      background_opacity = "0.6";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
    };

    themeFile = "vague";
  };
}
