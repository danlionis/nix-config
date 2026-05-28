{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tex-fmt
    texlab

    ltex-ls-plus
  ];
}
