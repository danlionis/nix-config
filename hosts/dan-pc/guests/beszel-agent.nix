{ config, pkgs, ... }:
let
  domain = config.globals.domains.beszel;
in
{
  age.secrets = {
    "beszel/dan-pc" = {
      file = ../../../secrets/beszel/dan-pc;
      owner = "beszel-agent";
    };
  };

  services.beszel.agent = {
    enable = true;

    environment = {
      GPU_COLLECTOR = "amd_sysfs";
      HUB_URL = "https://${domain}";
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgW+3PIPOUf3vhjEimo0xOcJV0UlyTBPlZsfo7N2qge";
      TOKEN_FILE = config.age.secrets."beszel/dan-pc".path;
    };
  };
}
