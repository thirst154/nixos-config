{pkgs, ...}: let
  themeFile = name: builtins.readFile (../../assets/ghostty-themes + "/${name}");
in {
  xdg.configFile = {
    "ghostty/config".text = ''
      theme = Evergarden Spring
      font-family = JetBrainsMono Nerd Font
      font-size = 15
      background-opacity = 0.8
    '';

    "ghostty/themes/Evergarden Fall".text = themeFile "Evergarden Fall";
    "ghostty/themes/Evergarden Winter".text = themeFile "Evergarden Winter";
    "ghostty/themes/Evergarden Spring".text = themeFile "Evergarden Spring";
    "ghostty/themes/Evergarden Summer".text = themeFile "Evergarden Summer";
  };
}
