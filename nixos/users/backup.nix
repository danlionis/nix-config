{ pkgs, ... }:

let
  backupKey = (import ../../keys.nix).backup;
  rrsyncCommand = "${pkgs.rrsync}/bin/rrsync ~/";
in
{
  users.users.backup = {
    isNormalUser = true;
    description = "Rsync backup user";
    home = "/home/backup";
    createHome = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "command=\"${rrsyncCommand}\",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ${backupKey}"
    ];
  };
}
