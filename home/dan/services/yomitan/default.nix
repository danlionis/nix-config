{ ... }:
{
  imports = [
    ./yomitan-api.nix
    ./yomitan-mecab.nix
  ];

  services.yomitan = {
    enableApi = true;
    enableMecab = true;

    braveApiIntegration = true;
    braveMecabIntegration = true;
  };
}
