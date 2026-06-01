{
  nixpkgs,
  nixpkgs-unstable,
  inputs,
  outputs,
}:
let
  mkNixosHost = import ./mkhost.nix {
    inherit nixpkgs;
    inherit inputs;
    inherit outputs;
  };

in
builtins.listToAttrs [
  (mkNixosHost "dan-pc" ../hosts/dan-pc {
    system = "x86_64-linux";
    graphical = true;
    home-manager = true;
    pkgs = nixpkgs;
  })

  (mkNixosHost "kronos" ../hosts/kronos {
    system = "aarch64-linux";
    pkgs = nixpkgs;
  })

  (mkNixosHost "vm-aarch64" ../hosts/vm-aarch64 {
    system = "aarch64-linux";
  })
]
