{ config, ... }:
let
  domain = config.globals.domains.beszel;
  cfg = config.services.beszel.hub;
in
{
  services.beszel.hub = {
    enable = true;
    environment = {
      APP_URL = "https://${domain}";
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:${toString cfg.port}
    '';
  };
}
