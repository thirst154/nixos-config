{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    uv

    nodejs
    pnpm
    typescript
    typescript-language-server
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

    # Ebitengine dependencies (graphics & audio libraries)
    mesa
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    alsa-lib

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
