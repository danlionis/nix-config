{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  niriInstance = lib.getExe (
    pkgs.writeShellScriptBin "niri-instance" ''
      ${config.programs.niri.package}/bin/niri --session
    ''
  );
in
{
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # inputs.ags.packages."x86_64-linux".ags # https://github.com/NixOS/nixpkgs/issues/306446
    # adw-gtk3

    bashmount
    bluetui
    brightnessctl
    clipse
    dunst
    gum
    hypridle
    hyprlock
    hyprpaper
    hyprpolkitagent
    hyprshot
    imagemagick
    impala
    libnotify
    networkmanagerapplet
    pavucontrol
    playerctl
    pywal
    quickshell
    satty
    slurp
    sway-audio-idle-inhibit
    tofi
    udiskie
    wiremix
    wl-clipboard
    wlogout
    wlsunset

    # TODO: https://github.com/YaLTeR/niri/issues/2463 switch back to stable when xwayland-satellite is on 0.8
    unstable.xwayland-satellite
    rose-pine-cursor

    xorg.xrdb # to set cursor size for steam for example
  ];

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    uwsm = {
      enable = true;
      package = pkgs.uwsm;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = niriInstance;
        };
      };
    };
  };

}
