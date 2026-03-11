{ pkgs, ... }: {
  programs.firefox.enable = true;

  # Nautilus needs GIO for trash, network mounts, etc.
  services.gvfs.enable = true;
  services.tumbler.enable = true;    # thumbnail service

  environment.systemPackages = with pkgs; [
    vscode
    git
    gh               # GitHub CLI
  ];

  programs.fzf.enable;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = ["--group-directories-first", "--header"];
  };

  # zoxide — smarter cd (learns your most-used dirs)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];   # replaces `cd` directly; use `z` for fuzzy jump
  };
}