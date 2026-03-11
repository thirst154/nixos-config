{ pkgs, ... }: {
  programs.firefox.enable = true;

  # Nautilus needs GIO for trash, network mounts, etc.
  services.gvfs.enable = true;
  services.tumbler.enable = true;    # thumbnail service

  environment.systemPackages = with pkgs; [
    vscode
    git
    gh               # GitHub CLI
    eza
    chromium
  ];

}
