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
    unstable.darktable
  ];

  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";

    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.mimeApps =
    let
      brave = "brave-browser.desktop";
    in
    {
      enable = true;
      associations.added = {
        "application/pdf" = [ brave ];
        "image/png" = [ "qimgv.desktop" ];
        "image/jpeg" = [ "qimgv.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = brave;
        "text/html" = brave;
        "x-scheme-handler/http" = brave;
        "x-scheme-handler/https" = brave;
        "x-scheme-handler/about" = brave;
        "x-scheme-handler/unknown" = brave;

        # --- Images ---
        "image/png" = "qimgv.desktop";
        "image/jpeg" = "qimgv.desktop";

        # --- Video ---
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop"; # .mkv files
        "video/webm" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";

        # --- Audio ---
        "audio/mpeg" = "mpv.desktop"; # .mp3
        "audio/flac" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
      };
    };

  gtk = {
    enable = true;

    theme = {
      name = "Orchis-Yellow-Dark";
      package = pkgs.orchis-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # icon-theme = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Orchis-Yellow-Dark";
  };
}
