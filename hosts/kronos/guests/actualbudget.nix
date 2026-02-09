{ config, pkgs, ... }:

let
  domain = config.globals.domains.actualbudget;
  port = 2909;
in
{
  services.actual = {
    enable = true;
    settings = {
      port = port;
    };
  };

  services.caddy.virtualHosts."${domain}".extraConfig = ''
    reverse_proxy http://localhost:${toString port} 
  '';
}
