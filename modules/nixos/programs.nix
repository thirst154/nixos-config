{
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    vscode
    gh
    eza
    chromium
    zed-editor
  ];
}
