{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    # package = pkgs.unstable.hyprland;
  };

  environment.systemPackages = with pkgs; [
    inputs.ags.packages."x86_64-linux".ags # https://github.com/NixOS/nixpkgs/issues/306446
    adw-gtk3

    brightnessctl
    clipse
    dunst
    gum
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    hyprsunset
    imagemagick
    impala
    libnotify
    libsForQt5.polkit-kde-agent
    networkmanagerapplet
    pavucontrol
    playerctl
    pywal
    rofi-wayland
    satty
    slurp
    sway-audio-idle-inhibit
    tofi
    udiskie
    wl-clipboard
    wlogout
    wlsunset

    unstable.wiremix
  ];

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
