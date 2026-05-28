{
  pkgs ?
    import
      (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
      })
      {
        config.allowUnfree = true;
        config.rocmSupport = true; # No longer strictly needed for this shell as we provide the overlay
        overlays = [ (import ./overlay.nix) ];
      },
}:

pkgs.mkShell {
  name = "whisperx-rocm-shell";

  packages = [
    (pkgs.python3.withPackages (ps: [
      ps.whisperx-rocm
    ]))
  ];

  # shellHook = ''
  #   export CT2_CUDA_ALLOCATOR=cub_caching
  # '';
}
