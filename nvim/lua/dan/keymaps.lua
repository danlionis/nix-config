vim.g.mapleader = " "

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- move selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- general
vim.keymap.set("n", "x", '"_x') -- dont copy to register

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

-- increment and decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number under cursor" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor" })

-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open explorer" })

-- edit and reload init.lua
vim.keymap.set("n", "<leader>ve", function(_) vim.api.nvim_command("edit $MYVIMRC") end,
  { desc = 'Open init.lua file' })
vim.keymap.set("n", "<leader>vr", function(_) vim.api.nvim_command("source $MYVIMRC") end,
  { desc = 'Reload init.lua file' })

-- splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window right" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window down" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Reset split size" })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current window" })

-- tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>")
vim.keymap.set("n", "<leader>tn", ":tabn<CR>")
vim.keymap.set("n", "<leader>tp", ":tabp<CR>")
vim.keymap.set("n", "<right>", ":tabn<CR>")
vim.keymap.set("n", "<left>", ":tabp<CR>")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
