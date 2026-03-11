{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # swap to your preference
      plugins = [
        "git"
        "docker"
        "rust"
        "node"
        "python"
        "golang"
        "z"
        "fzf"
      ];
    };

    shellAliases = {
      # replace the old ll alias with eza variants
      ls = "eza";
      ll = "eza -lah";
      lt = "eza --tree --level=2";
      la = "eza -a";

      gs = "git status";
      gc = "git commit";
      lg = "lazygit";
      rebuild = "~/nixos-config/rebuild.sh";
    };
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [
    "--cmd cd"
  ]; # fuzzy finder, used by zsh plugin
}
