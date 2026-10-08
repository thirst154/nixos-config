{
  inputs,
  pkgs,
  ...
}: let
  helium-fixed = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (
    old: let
      phase1 =
        builtins.replaceStrings ["--ozone-platform-hint=auto"] ["--ozone-platform=wayland"]
        old.installPhase;
      phase2 =
        builtins.replaceStrings
        ["--enable-features=WaylandWindowDecorations"]
        ["--enable-features=UseOzonePlatform,WaylandWindowDecorations"]
        phase1;
    in {
      installPhase = phase2;
    }
  );
in {
  # LocalSend with its firewall port open (TCP/UDP 53317) so inbound sharing works
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # Transmission: allow inbound peer connections (better swarm connectivity)
  networking.firewall.allowedTCPPorts = [51413];
  networking.firewall.allowedUDPPorts = [51413];

  environment.systemPackages = with pkgs; [
    vscode
    gh
    neovim
    neovide
    emacs
    kakoune
    helium-fixed
    zed-editor
    transmission_4-gtk
    protonmail-bridge
    thunderbird
    proton-pass
    haruna
    ffmpeg
    distrobox

    # AI
    t3code
    opencode
    tor-browser
    gnome-boxes
  ];

  environment.variables.EDITOR = "nvim";
}
