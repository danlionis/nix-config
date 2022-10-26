" https://neovim.io/doc/user/vimindex.html

set shell=/bin/bash

let mapleader = "\<Space>"

" To update Plugins run :PlugUpdate
" https://github.com/junegunn/vim-plug#commands
call plug#begin()

" source ~/.config/nvim/plugins/copilot.vim

source ~/.config/nvim/plugins/rust.vim
source ~/.config/nvim/plugins/svelte.vim

source ~/.config/nvim/plugins/coc.vim
source ~/.config/nvim/plugins/fzf.vim

source ~/.config/nvim/plugins/ayu.vim
source ~/.config/nvim/plugins/lightline.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/bufferline.vim

call plug#end()


" theme
set termguicolors
colo ayu
let ayucolor = "dark"
set background=dark

" bufferline
lua << EOF
require("bufferline").setup{
    options = {
        separator_style = "slant",
    }
}
EOF

" editor settings
set number
set autoindent
set relativenumber
set noshowmode
set mouse=a
set ignorecase
set nowrap

" tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set hidden
set splitbelow
set splitright

set nobackup
set nowritebackup


nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>
nmap gf :edit <cfile><cr>

map <silent> <esc> :noh<cr> " https://tech.serhatteker.com/post/2020-03/clear-search-highlight-in-vim/#ps
map <right> :bn<CR>
map <left> :bp<CR>
map <Leader>x :bd<CR>
map <Leader>X :bufdo bd<CR>
noremap <M-m> :!make<CR>
nnoremap <Leader>o :enew<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader><Leader> <c-^><CR>
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
map <F1> <Esc>
imap <F1> <Esc>

" relative numbers in normal, absolute in insert
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END



syntax enable
filetype plugin indent on


" permanent undo
set undodir=~/.vimdid
set undofile

