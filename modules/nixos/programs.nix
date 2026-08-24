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
  environment.systemPackages = with pkgs; [
    vscode
    gh
    neovim
    helium-fixed
    zed-editor
    localsend
    transmission_4-gtk
    haruna
    ffmpeg

    # AI
    t3code
    opencode
    tor-browser
    gnome-boxes
  ];

  environment.variables.EDITOR = "nvim";
}
