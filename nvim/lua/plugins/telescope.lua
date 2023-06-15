function telescope_builtin(builtin, opts)
    return function()
        require("telescope.builtin")[builtin](opts)
    end
end

return {
    {
        "nvim-telescope/telescope-symbols.nvim"
    },
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
        },
        cmd = "Telescope",
        keys = {
            { '<C-p>',     telescope_builtin("git_files"),       desc = 'Search git files' },
            { '<leader>,', telescope_builtin("oldfiles"),        desc = '[?] Find recently opened files' },
            { '<leader>:', telescope_builtin("command_history"), desc = '[:] Command History' },
            { '<leader>/', function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                telescope_builtin("current_buffer_fuzzy_find", require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })()
            end, { desc = '[/] Fuzzily search in current buffer]' } },
            {
                '<leader><space>',
                telescope_builtin("buffers"),
                desc =
                '[ ] Find existing buffers'
            },
            {
                '<leader>sf',
                telescope_builtin("find_files"),
                desc =
                '[S]earch [F]iles'
            },
            {
                '<leader>sh',
                telescope_builtin("help_tags"),
                desc =
                '[S]earch [H]elp'
            },
            {
                '<leader>sw',
                telescope_builtin("grep_string"),
                desc =
                '[S]earch [W]ord under cursor'
            },
            {
                '<leader>sg',
                telescope_builtin("live_grep"),
                desc =
                '[S]earch by [G]rep'
            },
            {
                '<leader>sd',
                telescope_builtin("diagnostics"),
                desc =
                '[S]earch [D]iagnostiscs'
            },
            {
                '<leader>sk',
                telescope_builtin("keymaps"),
                desc =
                '[S]earch [K]eymaps'
            },
            {
                '<leader>sb',
                telescope_builtin("builtin",
                    require('telescope.themes').get_dropdown({ previewer = false })),
                desc =
                '[S]earch [B]uiltin'
            },
            {
                '<leader>gb',
                telescope_builtin("git_branches"),
                desc =
                '[G]it [B]ranches'
            },
            {
                '<leader>gc',
                telescope_builtin("git_commits"),
                desc =
                '[G]it [C]ommits'
            },
            -- {
            --     "<leader>ss",
            --     telescope_builtin("lsp_document_symbols", {
            --         symbols = {
            --             "Class",
            --             "Function",
            --             "Method",
            --             "Constructor",
            --             "Interface",
            --             "Module",
            --             "Struct",
            --             "Trait",
            --             "Field",
            --             "Enum",
            --             "Property",
            --         },
            --     }),
            --     desc = "[S]earch [S]ymbols",
            -- },
        },
        opts = {
            defaults = {
                -- prompt_prefix = " ",
                -- selection_caret = " ",
                mappings = {
                    i = {
                        ["<C-h>"] = function()
                            telescope_builtin("find_files", { hidden = true })()
                        end,
                    },
                },
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)

            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')
        end,
    },
}
