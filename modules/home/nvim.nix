{pkgs, ...}: {
  xdg.configFile."nvim/init.lua".text = ''
    vim.g.mapleader = " "

    local map = vim.keymap.set

    map("n", "<leader>w", ":w<CR>")
    map("n", "<leader>so", ":so<CR>")
    map("n", "<leader>fe", ":Ex<CR>")

    vim.opt.nu = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"

    vim.opt.list = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.wrap = false

    vim.opt.termguicolors = true
    vim.cmd.colorscheme("catppuccin")

    vim.g.netrw_banner = 0

    vim.opt.spell = true
    vim.opt.spelllang = "en_gb"

    vim.pack.add({
        { src = "https://github.com/nvim-treesitter/nvim-treesitter" }
    })

    require("nvim-treesitter").setup({
        ensure_installed = { "go", "gomod", "gowork", "gosum", "lua" },
        highlight = { enable = true },
    })

    vim.pack.add({
        { src = "https://github.com/neovim/nvim-lspconfig" },
        { src = "https://github.com/mason-org/mason.nvim" },
        { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "gopls", "rust_analyzer" }
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, args.buf, { autocomplet = true })
            end
        end,
    })

    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    vim.pack.add({
        { src = "https://github.com/stevearc/conform.nvim" },
    })

    vim.keymap.set(
        { "n" },
        "<leader>cf",
        function()
            require("conform").format({
                async = true,
                lsp_fallback = true,
                timeout_ms = 500,
            })
        end,
        { desc = "Format file" }
    )

    map("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true })

    require("conform").setup(
        {
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 500,
            },
        }
    )

    vim.pack.add({
        { src = "https://github.com/nvim-mini/mini.nvim" }
    })

    require("mini.pick").setup()

    map("n", "<leader>fz", ":Pick files<CR>")
    map("n", "<leader>fh", ":Pick help<CR>")
    map("n", "<leader>fg", ":Pick grep_live<CR>")

    require("mini.pairs").setup()
  '';
}
