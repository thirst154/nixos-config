{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [

    # --- Python ---
    python3
    python3Packages.pip
    uv               # fast modern Python package manager

    # --- JavaScript / TypeScript ---
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    bun              # optional fast runtime

    # --- Rust ---
    rustup           # manages toolchains (stable, nightly, targets)

    # --- Go ---
    go
    gopls            # Go LSP

    # --- C / C++ ---
    gcc
    clang
    cmake
    gnumake
    pkg-config
    gdb

    # --- General dev tools ---
    docker
    docker-compose
    lazygit
    jq
    htop
    tree

    # -- AI --
    claude-code
  ];

  # Docker daemon
  #virtualisation.docker.enable = true;
  #users.users.thirst.extraGroups = [ "docker" ];

  # Needed for rustup to work properly on NixOS
  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };
}
