{ pkgs, ... }:
let
  domain = "pdf";
in
{
  services.bentopdf = {
    enable = true;
    package = pkgs.unstable.bentopdf;
    caddy = {
      enable = true;
      virtualHost = {
        listenAddresses = [ "127.0.0.1" ];
      };
    };
    domain = "http://${domain}";
  };

  networking.hosts = {
    "127.0.0.1" = [ domain ];
  };
}
