return {
    {
        'williamboman/mason.nvim',
        cmd  = "Mason",
        opts = {
            ensure_installed = {
                "black",
                "clangd",
                "codelldb",
                "debugpy",
                "gopls",
                "ltex-ls",
                "lua-language-server",
                "mypy",
                "ruff",
                "pyright",
                "rust-analyzer",
                "svelte-language-server",
                "texlab",
                "typescript-language-server",
            }
        },
        -- config = function(_, opts)
        --     require("mason").setup(opts)
        -- Vkkk
    }
}
