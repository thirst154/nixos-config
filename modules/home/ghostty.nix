{pkgs, ...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = Everforest Dark Hard
    font-family = JetBrainsMono Nerd Font
    font-size = 15
  '';
}
