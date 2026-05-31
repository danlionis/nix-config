{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3

    brightnessctl
    clipse
    dunst
    gum
    hypridle
    hyprlock
    hyprpaper
    hyprpolkitagent
    hyprshot
    hyprsunset
    imagemagick
    impala
    libnotify
    networkmanagerapplet
    playerctl
    pywal
    rose-pine-hyprcursor
    satty
    slurp
    sway-audio-idle-inhibit
    tofi
    udiskie
    wiremix
    wl-clipboard
    wlogout
    wlsunset
    xrdb # to set cursor size for steam for example
  ];

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
