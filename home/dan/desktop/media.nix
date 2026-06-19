{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    qimgv
    kdePackages.okular
    vlc
  ];
}
