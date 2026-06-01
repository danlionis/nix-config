{ outputs, inputs }:
{
  modifications = final: prev: {
  };

  # https://discourse.nixos.org/t/use-unstable-version-for-some-packages/32880
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };
}
