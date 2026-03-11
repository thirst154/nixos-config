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
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #1e1e1e;
        color: #ffffff;
      }

      /* ── Workspaces ── */
      #workspaces button {
        padding: 0 8px;
        color: #888888;
        background: transparent;
      }

      #workspaces button.active {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      #workspaces button:hover {
        color: #cccccc;
        background: #2a2a2a;
      }

      /* ── Clock ── */
      #clock {
        color: #ffffff;
        font-weight: bold;
      }

      /* ── Right modules ── */
      #window,
      #backlight,
      #pulseaudio,
      #network,
      #battery,
      #tray {
        padding: 0 10px;
        color: #ffffff;
      }

      #battery.warning {
        color: #f0c060;
      }

      #battery.critical {
        color: #ff6060;
      }

      /* subtle separators between right modules */
      #backlight,
      #pulseaudio,
      #network,
      #battery {
        border-left: 1px solid #333333;
      }
    '';
  };
}
