set PATH $PATH $HOME/.cargo/bin
set PATH $PATH $HOME/.local/bin

set EDITOR /usr/bin/nvim

fzf_key_bindings
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# autojump
if test -f /home/dan/.from_src/autojump-rs/integrations/autojump.fish;
    source /home/dan/.from_src/autojump-rs/integrations/autojump.fish;
end

source /home/dan/.config/fish/fish_greeting.fish

starship init fish | source
