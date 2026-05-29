{
  pkgs,
  ...
}: {
  xdg.configFile."ghostty/config".text = ''
    theme = Rose Pine
    font-family = JetBrainsMono Nerd Font
    font-size = 15
  '';
}
