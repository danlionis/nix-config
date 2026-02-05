{
  lib,
  pkgs,
  config,
  ...
}:
let
  domain = config.globals.domains.git;
  cfg = config.services.forgejo;
in
{
  services.forgejo = {
    package = pkgs.forgejo;
    enable = true;
    user = "git";
    group = "git";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = domain;
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${domain}/";
        HTTP_PORT = 3000;
        # SSH_PORT = 2222;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;

      session.COOKIE_SECURE = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:3000
    '';
  };
}
