{
  config,
  pkgs,
  ...
}:
{
  age.secrets."CLOUDFLARE_DNS_API_TOKEN".file = ../../secrets/CLOUDFLARE_DNS_API_TOKEN;

  services.caddy = {
    enable = true;
    package = pkgs.unstable.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.1"
      ];
      hash = "sha256-j+xUy8OAjEo+bdMOkQ1kVqDnEkzKGTBIbMDVL7YDwDY=";
    };
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
    '';
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.age.secrets."CLOUDFLARE_DNS_API_TOKEN".path;
  };
}
