set PATH $PATH $HOME/.cargo/bin
set PATH $PATH $HOME/.local/bin

set EDITOR /usr/bin/nvim

# cargo
abbr -a c cargo
abbr -a ct cargo test

# ls
if command -v exa > /dev/null
    abbr -a l "exa"
    abbr -a ls "exa"
    abbr -a ll "exa -l"
    abbr -a lll "exa -la"
else
    abbr -a ll "ls -l"
    abbr -a lll "ls -la"
end

# editor
abbr -a e "nvim"
abbr -a vi "nvim"
abbr -a vim "nvim"
abbr -a eixt "exit"

abbr -a m "make"
abbr -a gp "git push"

abbr -a dcup "docker-compose up"
abbr -a dcdown "docker-compose down"

fzf_key_bindings
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

if test -f $HOME/.nvm/nvm.sh
    nvm use --silent node
end

# autojump
if test -f /home/dan/.from_src/autojump-rs/integrations/autojump.fish;
    source /home/dan/.from_src/autojump-rs/integrations/autojump.fish;
end

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /home/dan/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /home/dan/.ghcup/bin $PATH

source /home/dan/.config/fish/fish_greeting.fish

starship init fish | source
