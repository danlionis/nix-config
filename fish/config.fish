set -gx EDITOR /usr/bin/nvim

fzf_key_bindings
set -gx FZF_DEFAULT_OPTS "--height 40%"
set -gx FZF_CTRL_T_OPTS "--border --preview 'bat --color=always {}'"
set -gx FZF_CTRL_R_OPTS "--border"

# set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
# set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

source /home/dan/.config/fish/fish_greeting.fish

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end
