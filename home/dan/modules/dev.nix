{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # python
    python3
    pyright
    ruff

    # nix
    nixd
    nixfmt

    # bash
    shellcheck
    shfmt
    bash-language-server

    # lua
    lua-language-server
    stylua

    # latex
    tex-fmt
    texlab
    ltex-ls-plus

    # html
    vscode-langservers-extracted
    prettierd
    tailwindcss-language-server
    rustywind

    # go
    gopls
    gofumpt
  ];
}
