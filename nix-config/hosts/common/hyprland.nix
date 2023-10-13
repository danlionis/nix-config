{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dunst
    eww-wayland
    grim
    hyprpaper
    imagemagick
    libnotify
    networkmanagerapplet
    pywal
    rofi-wayland
    slurp
    swappy
    swayidle
    swaylock-effects
    udiskie
    waybar
    wl-clipboard
  ];

  services.udisks2.enable = true;
}
