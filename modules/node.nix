{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  name = config.node.name;
in
{
  options.node = {
    name = mkOption {
      description = "Name for the host. Also sets the hostname";
      type = types.str;
    };
  };

  config = {
    networking.hostName = lib.mkDefault name;
    environment.sessionVariables = {
      NODE_NAME = name;
    };
  };
}
