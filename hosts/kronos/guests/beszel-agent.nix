{ config, ... }:
{
  age.secrets = {
    "beszel/kronos" = {
      file = ../../../secrets/beszel/kronos;
      owner = "beszel-agent";
    };
  };

  services.beszel.agent = {
    enable = true;

    environment = {
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgW+3PIPOUf3vhjEimo0xOcJV0UlyTBPlZsfo7N2qge";
      TOKEN_FILE = config.age.secrets."beszel/kronos".path;
    };
  };
}
