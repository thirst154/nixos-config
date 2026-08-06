{pkgs, ...}: {
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["battery" "pulseaudio" "backlight" "memory" "cpu"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          persistent-workspaces = {
            "eDP-1" = [1 2 3 4 5];
          };
          format = "{icon}";
          format-icons = {
            "1" = "●";
            "2" = "●";
            "3" = "●";
            "4" = "●";
            "5" = "●";
            "urgent" = "●";
            "active" = "●";
            "default" = "○";
          };
          on-click = "activate";
        };

        clock = {
          interval = 60;
          format = "{:%H:%M}";
          tooltip-format = "{:%A, %B %d, %Y}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = " M";
          format-icons = {
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{percent}% ";
        };

        memory = {
          format = "{}% ";
          interval = 5;
        };

        cpu = {
          format = "{usage}% ";
          interval = 5;
        };
      }
    ];

    style = ''
      * {
          font-family: JetBrainsMonoNL Nerd Font, sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(30, 30, 30, 0.95);
          color: #ffffff;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
          padding: 0 6px;
          background: transparent;
          color: #5a5a5a;
          border: none;
          box-shadow: none;
          text-shadow: none;
          font-size: 10px;
      }

      #workspaces button.active {
          color: #ffffff;
      }

      #workspaces button.urgent {
          color: #f53c3c;
      }

      #clock {
          font-weight: bold;
          padding: 0 12px;
      }

      #battery,
      #pulseaudio,
      #backlight,
      #memory,
      #cpu {
          padding: 0 10px;
      }

      #battery.charging,
      #battery.plugged {
          color: #2ecc71;
      }

      #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      @keyframes blink {
          to {
              color: #000000;
              background-color: #f53c3c;
          }
      }
    '';
  };
}
