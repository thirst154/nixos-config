{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      background_opacity = "0.8";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    themeFile = "vague";
  };
}
