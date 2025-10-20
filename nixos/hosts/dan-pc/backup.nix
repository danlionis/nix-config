{ config, pkgs, ... }:
{
  age.secrets."restic/password".file = ../../../secrets/restic/password;

  users.users.restic = {
    isNormalUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups = {
    daily-local = {
      initialize = true;

      user = "restic";

      package = pkgs.writeShellScriptBin "restic" ''
        exec /run/wrappers/bin/restic "$@"
      '';

      repository = "/mnt/backup/dan";

      passwordFile = config.age.secrets."restic/password".path;

      paths = [
        "${config.users.users.dan.home}/Documents"
        "${config.users.users.dan.home}/Pictures"
        "${config.users.users.dan.home}/Videos"
        "${config.users.users.dan.home}/dev"
        "${config.users.users.dan.home}/uni"
        "${config.users.users.dan.home}/.config"
        "${config.users.users.dan.home}/.ssh/config"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];

      exclude = [
        ".venv"
        "venv"
        "node_modules"
        "target"
        ".gradle"
        "build"
        "__pycache__"
        "dist"
      ];
    };
  };

  age.secrets."restic/ssh_key" = {
    file = ../../../secrets/restic/ssh_key;
    owner = "restic";
    group = "users";
    mode = "0400";
  };

  systemd.services."rsync-backup-remote" = {
    description = "Sync local Restic repository to remote server";
    after = [ "restic-backups-daily-local.service" ];
    wants = [ "restic-backups-daily-local.service" ];
    path = [
      pkgs.rsync
      pkgs.openssh
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "restic";
      ExecStart =
        let
          keyfile = config.age.secrets."restic/ssh_key".path;
          backupDir = "/mnt/backup/dan/";
          user = "backup";
          host = config.globals.domains.backup;
          name = "dan-pc";
        in
        pkgs.writeShellScript "rsync-backup-remote" ''
          rsync -avz --delete --partial -e "ssh -i ${keyfile} -o StrictHostKeyChecking=yes" ${backupDir} ${user}@${host}:${name}
        '';
    };
  };

  systemd.timers."rsync-backup-remote" = {
    description = "Timer for rsync backup to remote";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
