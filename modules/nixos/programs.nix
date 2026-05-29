{
  inputs,
  pkgs,
  ...
}: let
  neovim-0-12 = pkgs.stdenv.mkDerivation rec {
    pname = "neovim";
    version = "0.12.2";

    src = pkgs.fetchurl {
      url = "https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux-x86_64.tar.gz";
      sha256 = "31cf85945cb600d96cdf69f88bc68bec814acbff50863c5546adef3a1bcef260";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.libuv
      pkgs.luajit
      pkgs.libtermkey
      pkgs.libvterm-neovim
      pkgs.tree-sitter
    ];

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
    '';

    meta = {
      description = "Vim text editor fork focused on extensibility and usability";
      homepage = "https://neovim.io";
      license = pkgs.lib.licenses.asl20;
      platforms = pkgs.lib.platforms.linux;
      mainProgram = "nvim";
    };
  };
in {
  environment.systemPackages = with pkgs; [
    vscode
    gh
    eza
    neovim-0-12
    inputs.helium.packages.${pkgs.system}.default
    zed-editor

    # AI
    opencode
  ];

  environment.variables.EDITOR = "nvim";
}
