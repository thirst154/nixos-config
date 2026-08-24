{pkgs, ...}: {
  virtualisation.docker.enable = true;

  # KVM/libvirt backend for GNOME Boxes
  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    # General development tools
    direnv
    just
    lazygit
    jq
    htop
    tree

    # Python
    python3
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

    # Elixir
    elixir
    elixir-ls

    # Lua
    lua-language-server
    stylua

    # Nix
    nil
    nixfmt

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

    alsa-lib
  ];

  environment.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };
}
