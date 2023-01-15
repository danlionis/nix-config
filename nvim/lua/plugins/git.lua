return {
    -- Git related plugins
    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gs", "<cmd>0G<cr>", { desc = "Git Status" } }
        }
    },

    'tpope/vim-rhubarb',

    {
        'lewis6991/gitsigns.nvim',
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
