return {
    -- Git related plugins
    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gs", "<cmd>0G<cr>", { desc = "Git Status" } }
        }
    },

    -- open github urls
    {
        'tpope/vim-rhubarb',
        cmd = "GBrowse",
    },

    {
        'lewis6991/gitsigns.nvim',
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        }
    }
}
