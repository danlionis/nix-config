{ pkgs, ... }:
{
  home.packages = with pkgs; [
    shellcheck
    shfmt
    bash-language-server
  ];
}
