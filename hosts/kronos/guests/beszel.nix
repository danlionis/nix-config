{ config, pkgs, ... }:
let
  domain = config.globals.domains.beszel;
  cfg = config.services.beszel.hub;
in
{
  services.beszel.hub.enable = true;

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:${toString cfg.port}
    '';
  };
}
