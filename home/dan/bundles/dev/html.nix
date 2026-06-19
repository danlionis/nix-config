{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-langservers-extracted
    prettierd
    tailwindcss-language-server
    rustywind
  ];
}
