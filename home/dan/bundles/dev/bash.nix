{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bash-language-server
    beautysh
    shellcheck
    shfmt
  ];
}
