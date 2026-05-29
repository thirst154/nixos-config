{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    python3Packages.pip
    uv

    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    bun

    rustup

    go
    gopls

    gcc
    clang
    cmake
    gnumake
    pkg-config
    gdb

    docker
    docker-compose
    lazygit
    jq
    htop
    tree
  ];

  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };
}
