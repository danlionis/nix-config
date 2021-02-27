set shell=/bin/bash

let mapleader = "\<Space>"

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


" relative numbers in normal, absolute in insert
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

syntax enable
filetype plugin indent on

" plugins
" call plug#begin('~/.config/nvim/plugins')
" 
" " editorconfig 
" Plug 'editorconfig/editorconfig-vim'
" 
" " fuzzy finder
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
" 
" " UI
" Plug 'itchyny/lightline.vim'
" Plug 'machakann/vim-highlightedyank'
" 
" " language server
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 
" " languages
" Plug 'rust-lang/rust.vim'
" Plug 'neovimhaskell/haskell-vim'
" Plug 'cespare/vim-toml'
" 
" " git
" Plug 'airblade/vim-gitgutter'
" 
" " color scheme
" Plug 'rakr/vim-one'
" Plug 'ayu-theme/ayu-vim'
" Plug 'jacoborus/tender.vim'
" 
" call plug#end()

" color
set termguicolors
colo ayu
let ayucolor = "dark"
set background=dark

inoremap <silent><expr> <c-space> coc#refresh()

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB> 
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" lightline
" let g:lightline = {
"         \ 'colorscheme': 'powerline',
"         \ 'active': {
"         \   'left' [ ['mode', 'paste'],
"         \            ['coc'status
"         \ }
"     \ }

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'filename', 'cocstatus', 'git_status', 'readonly', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'git_status': 'GitStatus',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

function! LightlineFilename()
    return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
endfunction

" code action
nmap <Leader>a :CocAction<cr>
    

" format
command! -nargs=0 Format :call CocAction('format')
nmap <Leader>f :Format<CR>
nmap <C-M-l> :Format<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" buf
map <right> :bn<CR>
map <left> :bp<CR>

" rust
let g:rustfmt_autosave = 1

" hotkeys
map <C-p> :Files<CR>
map <C-M-p> :Buffers<CR>
map <Leader>b :Buffers<CR>
map <Leader>x :bd<CR>

" permanent undo
set undodir=~/.vimdid
set undofile

" make
noremap <M-m> :!make<CR>

" shortcuts
nnoremap <Leader>o :enew<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader><Leader> <c-^><CR>
nnoremap <c-s> :Rg<CR>


map <F1> <Esc>
imap <F1> <Esc>

map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
