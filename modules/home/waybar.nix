{ ... }: {
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" "battery" "tray" ];

      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip-format = "{calendar}";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = " {ifname}";
        format-disconnected = "⚠ Disconnected";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-icons = { default = ["" ""]; };
        on-click = "pavucontrol";
      };
    }];
  };
}