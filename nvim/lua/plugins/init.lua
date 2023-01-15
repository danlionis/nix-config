return {
    -- Detect tabstop and shiftwidth automatically
    {
        'tpope/vim-sleuth',
        event = "BufReadPre",
    },

    {
        'mbbill/undotree',
        event = "BufReadPost",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, { desc = "Open [u]ndotree" } }
        }
    },

    -- todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "BufReadPost",
        config = true,
        -- stylua: ignore
        keys = {
            -- TODO: find better keybindings
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
            { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
            { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]odos" },
        },
    },

    --[[ -- better diagnostics list and others
    -- NOTE: maybe we can remove this, does not seem too useful
    {
        "folke/trouble.nvim",
        enabled = false,
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            -- TODO: find better keybindings
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
        },
    }, ]]
}
