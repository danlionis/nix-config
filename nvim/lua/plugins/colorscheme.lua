return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "moon" },
    },

    {
        'rose-pine/neovim',
        lazy = true,
        as = 'rose-pine',
        -- config = function()
        --     vim.cmd('colorscheme rose-pine')
        -- end
    },

    -- {
    --     'kaicataldo/material.vim',
    --     config = function()
    --         vim.g.material_theme_style = "darker"
    --         vim.cmd('colorscheme material')
    --     end
    -- },

    {
        'ayu-theme/ayu-vim',
        config = function()
            vim.env.ayucolor = "light"
            vim.cmd('colorscheme ayu')
        end
    },
}
