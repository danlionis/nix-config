return {
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = function()

            local function fg(name)
                return function()
                    ---@type {foreground?:number}?
                    local hl = vim.api.nvim_get_hl_by_name(name, true)
                    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
                end
            end

            return {
                options = {
                    theme = "auto",
                    -- icons_enabled = false,
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        { "diagnostics", },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { "filename", path = 1, symbols = { modified = "*", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        {
                            require("nvim-navic").get_location, cond = require("nvim-navic").is_available
                        },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.command.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        --     color = fg("Statement")
                        -- },
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.mode.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        --     color = fg("Constant"),
                        -- },
                        { require("lazy.status").updates, cond = require("lazy.status").has_updates,
                            color = fg("Special") },
                        { "diff", },
                    },
                    lualine_y = {
                        { "progress", separator = "", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return os.date("%R")
                        end,
                    },
                },
                extensions = {
                    "fugitive",
                }
            }
        end,
    },

    -- lsp symbol navigation for lualine
    {
        "SmiteshP/nvim-navic",
        opts = { separator = " ", highlight = true, depth_limit = 5 },
        depencendies = {
            "neovim/nvim-lspconfig"
        }
    },
} -- Fancier statusline
