return {
    {
        "stevearc/conform.nvim",
        event = 'BufWritePre', -- uncomment for format on save
        config = function() require "configs.conform" end
    }, -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require "configs.lspconfig"
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                -- defaults 
                "vim", "lua", "vimdoc", 
                -- nix
                "nix", 
                -- web dev 
                "html", "css", "javascript", "typescript", "tsx", 
                -- low level
                "c", "zig"
            }
        }
    },
}
