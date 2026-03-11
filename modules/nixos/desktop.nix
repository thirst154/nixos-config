{ pkgs, ... }: {

  # Ly display manager
  services.displayManager.ly.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Wayland / XDG portal (needed for screen share, file picker, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Audio (Pipewire — standard for Wayland)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Needed for Hyprland screen locking, polkit, etc.
  security.polkit.enable = true;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    kitty          # terminal
    waybar         # status bar
    nautilus       # file manager
    hyprpaper      # wallpaper
    hyprlock       # screen lock
    hypridle       # idle daemon
    dunst          # notifications
    wofi           # app launcher
    wl-clipboard   # clipboard
    grim slurp     # screenshot tools
    brightnessctl  # brightness
    playerctl      # media keys
    networkmanagerapplet
    pavucontrol    # audio GUI
    gearlever
  ];
}