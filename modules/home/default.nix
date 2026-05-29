{pkgs, inputs, ...}: {
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
  ];

  home.stateVersion = "24.11";
}
