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
    xorg.xrdb # to set cursor size for steam for example
  ];

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
