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
    libX11
    mesa
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    alsa-lib

    lazygit
    jq
    htop
    tree

    # Cloudflare
    wrangler
  ];

  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };
}
