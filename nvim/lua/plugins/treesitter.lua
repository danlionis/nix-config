return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        ---@type TSConfig
        opts = {
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            ensure_installed = { 'c',
                'go',
                'lua',
                'python',
                'rust',
                'javascript',
                'typescript',
                'help',
                'fish',
                "bash",
                "html",
                "javascript",
                "json",
                "markdown",
                "markdown_inline",
                "query",
                "regex",
                "typescript",
                "vim",
                "yaml",
            },
            playground = {
                enable = true,
            }
        },
        ---@param opts TSConfig
        config = function(_, opts)
            -- if plugin.ensure_installed then
            --   require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
            -- end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },

    {
        "nvim-treesitter/nvim-treesitter-context"
    }
}
