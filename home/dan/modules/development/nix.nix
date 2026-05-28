{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    shellcheck
    shfmt

    bash-language-server
  ];
}
