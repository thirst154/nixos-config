{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = ["git"];
    };

    initContent = ''
      # fastfetch on terminal start
      fastfetch

      # pnpm
      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:") ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
    '';

    sessionVariables = {
      NVM_DIR = "$HOME/.nvm";
    };

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --header --icons";
      la = "eza -la --header --icons";
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = ["--cmd cd"];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.sessionPath = [
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
    "/usr/local/go/bin"
  ];
}
