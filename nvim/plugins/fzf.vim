" fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" https://youtu.be/434tljD-5C8?t=963
command! -bang -nargs=? -complete=dir Files
            \ call fzf#run(fzf#wrap('files', fzf#vim#with_preview({ 'dir': <q-args>, 'source': 'rg --files --hidden' }), <bang>0)) 

map <C-p> :Files<CR>
map <Leader>f :Files<CR>
map <C-M-p> :Commands<CR>
map <Leader>b :Buffers<CR>
map <C-f> :Rg<CR>
