{ ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/thirst/nixos-config/assets/background.jpg" ];
      wallpaper = [ ",/home/thirst/nixos-config/assets/background.jpg" ];
    };
  };
}
