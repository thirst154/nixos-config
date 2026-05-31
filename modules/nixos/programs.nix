{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vscode
    gh
    neovim
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    zed-editor

    localsend
    transmission_4-gtk
    haruna
    ffmpeg

    # AI
    opencode

    # Gaming
    atlauncher
  ];

  environment.variables.EDITOR = "nvim";
}
