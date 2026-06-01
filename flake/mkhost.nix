{
  nixpkgs,
  inputs,
  outputs,
}:
name: modulePath:
{
  system,
  graphical ? false,
  unfree ? true,
  home-manager ? false,
  pkgs ? nixpkgs,
}:
{
  name = name;
  value = pkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs outputs graphical;
    };
    modules = [
      {
        nixpkgs.config.allowUnfree = unfree; # allow unfree packages.

        # apply overlays
        nixpkgs.overlays = builtins.attrValues outputs.overlays ++ [
          # put some other overlays here
        ];

        node.name = name;
      }

      inputs.agenix.nixosModules.default

      ../modules/node.nix
      ../modules/globals.nix
      ../globals.nix # TODO: put this somewhere else maybe

      modulePath
    ]
    ++ nixpkgs.lib.optionals home-manager [
      # put home manager somewhere else
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.dan = import ../home/dan/${name}.nix;
        home-manager.extraSpecialArgs = {
          inherit inputs;
        };
      }
    ];
  };
}
