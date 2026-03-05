{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # fcitx5-mozc
      fcitx5-mozc-ut
      fcitx5-gtk
    ];
  };

  fonts.packages = with pkgs; [
    source-han-sans
    source-han-serif
    ipafont
  ];
}
