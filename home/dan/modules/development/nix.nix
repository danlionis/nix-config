{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt
    shellcheck
    shfmt

    bash-language-server
  ];
}
