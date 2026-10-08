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
      # pnpm
      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:") ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # TR-100 Machine Report, only when in interactive mode
      if [[ -o interactive ]]; then
        ${pkgs.bash}/bin/bash ${./scripts/machine_report.sh}
      fi
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
      zed = "zeditor";
      oc = "opencode";
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
    "$HOME/go/bin" # where `go install` puts binaries
  ];
}
