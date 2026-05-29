{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./shell.nix
    ./hyprland.nix
    ./waybar.nix
    ./mako.nix
    ./hyprlock.nix
    ./ghostty.nix
    ./kitty.nix
    ./nvim.nix
    ./fastfetch.nix
    ./scripts.nix
    ./gtk.nix
    ./git.nix
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "waybar";
      placeholders."default" = {
        input = "Search";
        list = "No Results";
      };
      keybinds = {
        close = ["Escape"];
        next = ["Down"];
        previous = ["Up"];
        quick_activate = ["F1" "F2" "F3" "F4"];
      };
      providers.prefixes = [
        {
          provider = "websearch";
          prefix = "+";
        }
        {
          provider = "providerlist";
          prefix = ";";
        }
      ];
    };

    themes = {
      "waybar" = {
        style = ''
          @define-color bg rgba(30, 30, 30, 0.95);
          @define-color fg #ffffff;
          @define-color accent rgba(255, 255, 255, 0.1);
          @define-color border rgba(255, 255, 255, 0.1);

          * {
            all: unset;
            font-family: "JetBrainsMonoNL Nerd Font", sans-serif;
            font-size: 13px;
          }

          .box-wrapper {
            background: @bg;
            border: 1px solid @border;
            border-radius: 0;
            padding: 8px 12px;
            box-shadow: none;
          }

          .input {
            background: transparent;
            color: @fg;
            padding: 6px 0;
            border-bottom: 1px solid @border;
            caret-color: @fg;
          }

          .input placeholder {
            color: rgba(255, 255, 255, 0.4);
          }

          .input:focus {
            outline: none;
          }

          .list {
            color: @fg;
            margin-top: 4px;
          }

          .item-box {
            border-radius: 0;
            padding: 6px 4px;
          }

          child:selected .item-box {
            background: @accent;
          }

          .item-subtext {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.5);
          }

          .item-image-text {
            font-size: 16px;
          }

          .keybinds {
            padding-top: 4px;
            border-top: 1px solid @border;
            font-size: 11px;
            color: rgba(255, 255, 255, 0.4);
          }

          .keybind-label {
            padding: 1px 4px;
            border-radius: 2px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 10px;
          }
        '';
      };
    };
  };

  home.stateVersion = "24.11";
}
