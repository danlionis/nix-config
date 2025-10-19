{ config, pkgs, ... }:

{

  imports = [
    ./modules/global

    ./modules/desktop/gnome.nix
    ./modules/desktop/media.nix

    ./modules/terminal

    # ./modules/dotpersist-service.nix
    ./modules/openrgb-service.nix

    ./modules/development/nix.nix
    ./modules/development/python.nix
    ./modules/development/lua.nix
    ./modules/development/latex.nix

    ./modules/desktop/walker.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.packages = with pkgs; [
    exiftool
    orca-slicer
    prismlauncher
    rose-pine-hyprcursor
    darktable
  ];

  home.pointerCursor = {
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";

    size = 32;
    gtk.enable = true;
  };
}
