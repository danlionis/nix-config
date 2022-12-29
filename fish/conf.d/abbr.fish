# remove all abbreviations
for a in (abbr --list)
    abbr --erase $a
end

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

abbr -a cat "bat"
