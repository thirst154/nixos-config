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

    haruna
    ffmpeg

    # AI
    opencode
  ];

  environment.variables.EDITOR = "nvim";
}
