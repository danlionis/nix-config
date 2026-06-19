# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./disko.nix

    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.impermanence

    ../../users/dan.nix

    ../../modules/niri.nix
    ../../modules/fonts.nix
    # ../../modules/podman.nix
    # ../../modules/docker.nix
    # ../../modules/printing.nix
    ../../modules/sound.nix
    ../../modules/tailscale.nix
    ../../modules/terminal.nix
    # ../../modules/wireshark.nix
    # ../../modules/yubikey.nix
    # ../../modules/localsend.nix

    # ./guests/beszel-agent.nix
  ];

  users.users.dan.name = "lionis";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 30;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; # https://discourse.nixos.org/t/nixos-rebuild-switch-upgrade-networkmanager-wait-online-service-failure/30746
  # networking.networkmanager.dns = "none";
  # networking.nameservers = [ "127.0.0.1" "::1" ];
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
  # networking.firewall.checkReversePath = "loose";

  networking.hosts = {
    "127.0.0.1" = [
      "${config.networking.hostName}"
      "local.${config.globals.domains.lionis}"
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us";

  # services.https-dns-proxy.enable = true;
  # services.https-dns-proxy.port = 53;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs-stable}" ];

  environment.systemPackages = with pkgs; [
    # dev
    gcc
    gnumake

    # (anki.override { buildInputs = [ wrapGAppsHook ]; }) # Or system-wide
    unstable.anki

    # gui / desktop
    brave
    brightnessctl
    firefox
    kitty
    libreoffice
    obsidian
    piper
    ungoogled-chromium
    zotero
    inkscape

    # other
    openssl
    pkg-config
    chezmoi
    jc
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
      "abocjojdmemdpiffeadpdnicnlhcndcg" # https://chromewebstore.google.com/detail/socialfocus-%E2%80%94-hide-feeds/abocjojdmemdpiffeadpdnicnlhcndcg
      # "likgccmbimhjbgkjambclfkhldnlhbnn" # "https://chromewebstore.google.com/detail/yomitan-popup-dictionary/likgccmbimhjbgkjambclfkhldnlhbnn"
      "ffekmfclcdnahgaeagcmdcnbgkcjhfld" # https://chromewebstore.google.com/detail/stereotomono/ffekmfclcdnahgaeagcmdcnbgkcjhfld
      # "hoombieeljmmljlkjmnheibnpciblicm" # https://chromewebstore.google.com/detail/language-reactor/hoombieeljmmljlkjmnheibnpciblicm
    ];
  };

  # List services that you want to enable:

  services.flatpak.enable = true;

  environment.variables = {
    # NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  security.polkit.enable = true;

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  services.devmon.enable = true;

  # programs.ssh = {
  #   startAgent = true;
  #   agentTimeout = "1h";
  # };
}
