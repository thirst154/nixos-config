{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      monitor = [ ",preferred,auto,1" ];    # auto-detect monitor

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";

      exec-once = [
        "waybar"
        "dunst"
        "hypridle"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur.enabled = true;
      };

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, Space, exec, $menu"
        "$mod, C, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod SHIFT, E, exit"

        # Focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%s).png"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      input = {
        kb_layout = "gb";           # change to "us" etc.
        follow_mouse = 1;
        sensitivity = 0.6;
        touchpad.natural_scroll = true;
      };
    };
  };
}
