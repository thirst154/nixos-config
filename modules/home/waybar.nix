{ ... }: {
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 36;
      spacing  = 4;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "hyprland/window"
        "backlight"
        "pulseaudio"
        "network"
        "battery"
        "tray"
      ];

      # ── Left ────────────────────────────────────────────────────────────
      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
        sort-by-number = true;
      };

      # ── Center ──────────────────────────────────────────────────────────
      clock = {
        format         = "  {:%a %d %b   %H:%M}";
        tooltip-format = "{calendar}";
      };

      # ── Right ────────────────────────────────────────────────────────────
      "hyprland/window" = {
        format         = "{class}";
        separate-outputs = false;
        rewrite = {
          "(.*)" = "  $1";
        };
      };

      backlight = {
        format     = "{icon} {percent}%";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
        on-scroll-up   = "brightnessctl set +5%";
        on-scroll-down = "brightnessctl set 5%-";
      };

      pulseaudio = {
        format          = "{icon} {volume}%";
        format-muted    = "󰝟 Muted";
        format-icons    = { default = [ "" "" "󰕾" ]; };
        on-click        = "pavucontrol";
        on-scroll-up    = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down  = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      };

      network = {
        format-wifi       = "󰤨 {essid}";
        format-ethernet   = "󰈀 {ifname}";
        format-disconnected = "󰤭 Offline";
        tooltip-format-wifi = "{signalStrength}% — {frequency} GHz";
        on-click = "nm-connection-editor";
      };

      battery = {
        format          = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged  = "󰚥 {capacity}%";
        format-icons    = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        states = {
          warning  = 20;
          critical = 10;
        };
      };

      tray = {
        icon-size   = 16;
        spacing     = 8;
        show-passive-items = true;
      };
    }];

    style = ''
      * {
  font-family: "Hack Nerd Font", "JetBrains Mono", monospace;
  font-size: 14px;
  color: #d0cfcd;
  margin: 0;
  padding: 0;
  border: none;
}

window#waybar {
  background: #1b1c1d; /* semi-transparent */
  border-bottom: none;
  box-shadow: none;
  /* backdrop-filter: blur(10px); ❌ removed */
  transition: none;
  font-weight: bold;
}

#clock,
#battery,
#custom-dot,
#custom-gpu,
#network,
#pulseaudio,
#tray {
  padding: 0 10px;
}

#tray > .tray-item {
  margin: 0 4px;
}
    '';
  };
}
