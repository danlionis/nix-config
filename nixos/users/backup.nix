{ pkgs, ... }:

let
  backupKey = (import ../../keys.nix).backup;
in
{
  users.users.backup = {
    isNormalUser = true;
    description = "Rsync backup user";
    home = "/home/backup";
    createHome = true;
    shell = pkgs.nologin;
    openssh.authorizedKeys.keys = [ backupKey ];
  };
}
