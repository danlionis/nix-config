{ config, pkgs, ... }:

{
  imports = [
    ./yomitan-api.nix
    ./yomitan-mecab.nix
  ];
}
