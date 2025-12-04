{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ags.url = "github:Aylur/ags/v1"; # WARNING: migrate to v2, please do so soon...

    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
    };

    # # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    systems.url = "github:nix-systems/default";

    agenix = {
      url = "github:ryantm/agenix";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      # inputs.nixpkgs-stable.follows = "nixpkgs";
      # inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };

    # https://github.com/NixOS/nixpkgs/issues/448779
    elephant = {
      url = "github:abenz1267/elephant";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      disko,
      nix-darwin,
      home-manager,
      systems,
      agenix,
      deploy-rs,
      ghostty,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = function: nixpkgs-stable.lib.genAttrs (import systems) (system: function system);
    in
    {

      overlays = import ./pkgs { inherit inputs outputs; };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs-stable.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                lua-language-server
                stylua

                nixd
                nixfmt-rfc-style
                nodePackages.typescript-language-server

                pyright
              ]
              ++ [
                agenix.packages.${system}.default
                deploy-rs.packages.${system}.default
              ];
          };
        }
      );

      nixosConfigurations = import ./flake/hosts.nix {
        inherit inputs outputs;
        inherit (inputs) nixpkgs-unstable;
        nixpkgs = nixpkgs-stable;
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#dan-mbp
      darwinConfigurations."dan-mbp" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./darwin/mbp

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home/dan/mbp.nix;
          }
        ];
      };

      deploy.nodes = {

        kronos = {
          hostname = "kronos";
          profiles = {
            system = {
              remoteBuild = true;
              path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.kronos;
              user = "root";
              interactiveSudo = true;
            };
          };
        };
      };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    };
}
