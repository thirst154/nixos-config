{ ... }: {
  imports = [
    ./shell.nix
    ./hyprland.nix
    ./waybar.nix
    ./nvim.nix
  ];

  home.stateVersion = "24.11";
}