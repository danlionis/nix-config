{ lib, ... }:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/nvme0n1p2 /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    enable = true; # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/tailscale" # maybe move to own module
      "/var/lib/libvirt" # maybe move to own module
      "/var/lib/containers" # maybe move to own module
      "/var/lib/docker" # maybe move to own module
      "/var/lib/flatpak" # maybe move to own module
      "/var/lib/systemd/coredump"
      "/var/lib/OpenRGB"
      "/var/lib/systemd/timers"
      "/var/lib/private" # ollama

      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }

      "/home"
    ];
    files = [
      "/etc/machine-id"
      # { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    # users.dan = {
    #   directories = [
    #     ".persist"
    #
    #     "Documents"
    #     "Downloads"
    #     "Music"
    #     "Pictures"
    #     "Videos"
    #     "dev"
    #     "dotfiles"
    #     "uni"
    #
    #     ".local/share/Anki2"
    #     ".local/share/PrismLauncher"
    #     ".local/share/Steam"
    #     ".local/share/atuin"
    #     ".local/share/bottles"
    #     ".local/share/chezmoi"
    #     ".local/share/containers"
    #     ".local/share/direnv"
    #     ".local/share/fish"
    #     ".local/share/flatpak"
    #     ".local/share/nvim"
    #     ".local/share/zoxide"
    #
    #     ".local/state/lazygit"
    #     ".local/state/wireplumber"
    #
    #     ".cache/darktable"
    #     ".cache/nix-index"
    #     ".cache/zotero"
    #
    #     ".config"
    #
    #     ".var/app" # flatpak data
    #
    #     {
    #       directory = ".gnupg";
    #       mode = "0700";
    #     }
    #     {
    #       directory = ".ssh";
    #       mode = "0700";
    #     }
    #     {
    #       directory = ".local/share/keyrings";
    #       mode = "0700";
    #     }
    #
    #   ];
    #   files = [
    #     ".profile"
    #   ];
    # };
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  systemd.targets.timers.after = [ "var-lib-systemd-timers.mount" ]; # https://www.reddit.com/r/NixOS/comments/ryexzy/comment/kdc3ah0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
}
