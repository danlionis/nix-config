# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  inputs,
  outputs,
}:
let
  mkNixosHost =
    name: modulePath:
    {
      system,
      graphical ? false,
      home-manager ? false,
    }:
    {
      ${name} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs graphical;
        };
        modules = [
          {
            nixpkgs.config.allowUnfree = true; # allow unfree packages.

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
    };
in
{ }
// mkNixosHost "dan-pc" ../hosts/dan-pc {
  system = "x86_64-linux";
  graphical = true;
  home-manager = true;
}
// mkNixosHost "kronos" ../hosts/kronos { system = "aarch64-linux"; }
// mkNixosHost "vm-aarch64" ../hosts/vm-aarch64 { system = "aarch64-linux"; }
