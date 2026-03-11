{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # UI
      catppuccin-nvim
      lualine-nvim
      nvim-tree-lua
      telescope-nvim

      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip

      # Treesitter (syntax)
      nvim-treesitter.withAllGrammars

      # Git
      gitsigns-nvim
      vim-fugitive
    ];

    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.cmd("colorscheme catppuccin")
    '';
  };
}
