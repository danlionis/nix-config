{ config, pkgs, ... }:

let
  domain = config.globals.domains.linkding;
  # user = "linkding";
  # uid = 991;
  dataDir = "/var/lib/linkding";
  port = 9090;
in
{
  age.secrets."linkding/env" = {
    file = ../../../secrets/linkding/env;
  };

  # TODO: figure out how to do this rootless
  # users.users.${user} = {
  #   isSystemUser = true;
  #   group = user;
  #   uid = uid;
  #   home = dataDir;
  #   createHome = true;
  #   linger = false;
  #
  #   # autoSubUidGidRange = true;
  #
  #   subUidRanges = [
  #     {
  #       startUid = 100000;
  #       count = 65536;
  #     }
  #   ];
  #   subGidRanges = [
  #     {
  #       startGid = 100000;
  #       count = 65536;
  #     }
  #   ];
  # };
  # users.groups.${user} = { };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root - -"
  ];

  # 2. Container Config
  virtualisation.oci-containers.containers.linkding = {
    image = "sissbruecker/linkding:latest-plus";

    # podman.user = "${user}";

    volumes = [
      "${dataDir}:/etc/linkding/data"
    ];

    ports = [ "127.0.0.1:${toString port}:9090" ];

    environmentFiles = [
      config.age.secrets."linkding/env".path
    ];

    extraOptions = [
      "--add-host=auth.lionis.net:host-gateway"
    ];
  };

  services.caddy.virtualHosts."${domain}".extraConfig = ''
    reverse_proxy http://localhost:${toString port} {
        header_up Host {host}
        header_up X-Real-IP {remote_host}
      
        # Increase buffer sizes for long OIDC URLs
        transport http {
            read_buffer 16KiB
        }
    }
  '';
}
