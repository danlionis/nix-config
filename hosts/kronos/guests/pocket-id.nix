{ config, ... }:
let
  domain = config.globals.domains.auth;
in
{
  age.secrets = {
    "pocket-id/encryption_key" = {
      file = ../../../secrets/pocket-id/encryption_key;
      owner = config.services.pocket-id.user;
    };
  };

  services.pocket-id = {
    enable = true;
    settings = {
      TRUST_PROXY = true;
      APP_URL = "https://${domain}";
      ANALYTICS_DISABLED = true;
      ENCRYPTION_KEY_FILE = config.age.secrets."pocket-id/encryption_key".path;
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:1411 {
      }
    '';
  };

  services.restic.backups = {
    pocket-id-b2-daily = {
      initialize = true;

      repository = "s3:s3.eu-central-003.backblazeb2.com/danlionis-restic-pocket-id";
      environmentFile = config.age.secrets."restic/paperless-b2-env".path;
      passwordFile = config.age.secrets."restic/password".path;

      paths = [
        config.services.pocket-id.dataDir
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}
