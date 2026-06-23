{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # General development tools
    direnv
    just
    lazygit
    jq
    htop
    tree

    # Infra as code application
    pulumi-bin

    # Python
    python3
    uv
    ruff
    pyright

    # JavaScript / TypeScript
    nodejs
    pnpm
    bun
    typescript
    typescript-language-server
    prettierd

    # Rust
    rustup
    rust-analyzer

    # Go
    go
    gopls
    gofumpt
    delve

    # C / C++
    gcc
    clang
    cmake
    gnumake
    pkg-config
    gdb
    clang-tools

    # Lua
    lua-language-server
    stylua

    # Nix
    nil
    nixfmt-rfc-style

    # TOML
    taplo

    # Shell
    shellcheck
    shfmt

    # HTML / CSS / Emmet
    emmet-language-server

    # Markdown
    marksman

    # YAML
    yaml-language-server

    # Other
    actionlint

    # Cloudflare
    wrangler

    # Google Cloud
    google-cloud-sdk

    # Ebitengine dependencies (graphics & audio libraries)
    libX11
    mesa
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    alsa-lib
  ];

  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };
}
