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
    udiskie
    imagemagick
    rofi-wayland
    slurp
    wl-clipboard
    swappy
    swayidle
    swaylock-effects
    waybar
    libnotify
    networkmanagerapplet
  ];

  services.udisks2.enable = true;
}
