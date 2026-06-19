{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages =
    let
      commonPackages = with pkgs; [
        atuin
        bat
        bitwarden-cli
        btop
        carapace
        comma
        dig
        eza
        fd
        file
        fzf
        fzf-preview
        gdu
        jq
        lazygit
        man-pages
        man-pages-posix
        navi
        nodejs
        nushell
        prettierd
        taplo
        ripgrep
        starship
        tldr
        tree-sitter
        unzip
        wget
        yazi
        yt-dlp
        zip
        zoxide
        neovim
      ];
      linuxPackages = with pkgs; [
        distrobox
      ];
      darwinPackages = [ ];
      unfreePackages = with pkgs; [
        unstable.antigravity-cli
      ];
    in
    commonPackages
    ++ lib.optionals pkgs.stdenv.isLinux linuxPackages
    ++ lib.optionals (pkgs.config.allowUnfree or false) unfreePackages
    ++ lib.optionals pkgs.stdenv.isDarwin darwinPackages;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Dan Lionis";
    };
    ignores = [
      ".direnv"
      ".envrc"
      "result"
    ];

    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
