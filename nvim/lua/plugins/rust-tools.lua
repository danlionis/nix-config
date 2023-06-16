return {
    {
        "simrat39/rust-tools.nvim",
        opts = {
            server = {
                on_attach = function(client, bufnr)
                    require("dap")
                    require("dapui")
                    -- require("plugins.lsp.keymaps").on_attach(client, bufnr)
                    -- require("plugins.lsp.format").on_attach(client, bufnr)
                    vim.keymap.set("n", "<C-space>", function()
                        require("rust-tools").hover_actions.hover_actions()
                    end, { buffer = bufnr })
                end
            },
        },
        config = function(_, opts)
            local mason_registry = require("mason-registry")

            local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
            local codelldb_path = codelldb_root .. "adapter/codelldb"
            local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

            opts.dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
            }

            require("rust-tools").setup(opts)
        end
    }
}
