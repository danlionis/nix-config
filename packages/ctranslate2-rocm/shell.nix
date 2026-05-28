let
  stable = import <nixpkgs> {
    config.allowUnfree = true;
    config.rocmSupport = true;
  };
  pkgs =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
      })
      {
        config.allowUnfree = true;
        config.rocmSupport = true;
      };

  ctranslate2-cpp = pkgs.callPackage ./derivation.nix { };

  python = pkgs.python3.override {
    packageOverrides = pyfinal: pyprev: {

      ctranslate2 = pyprev.ctranslate2.overrideAttrs (old: {
        inherit (ctranslate2-cpp) version src;
        pyproject = true;
        postPatch = ''
          substituteInPlace install_requirements.txt \
            --replace-fail "pybind11==" "pybind11>="
        '';
        buildInputs = (old.buildInputs or [ ]) ++ [ ctranslate2-cpp ];

        # doCheck = false;

        # Make it clear this is the ROCm build
        passthru = (old.passthru or { }) // {
          # isRocm = true;
          ctranslate2-cpp = ctranslate2-cpp;
        };
      });

      ctranslate2-rocm = pyfinal.ctranslate2;

      # pyannote-audio = pyprev.pyannote-audio.overrideAttrs (old: {
      #   postPatch = (old.postPatch or "") + ''
      #     # Relax strict version pins that clash with newer Nixpkgs
      #     substituteInPlace pyproject.toml \
      #       --replace-fail "torch==2.8.0" "torch>=2.8.0" \
      #       --replace-fail "torchcodec==0.7.0" "torchcodec>=0.7.0"
      #   '';
      # });

      # faster-whisper = pyprev.faster-whisper.override {
      #   ctranslate2 = pyfinal.ctranslate2;
      # };

      # torch = pyprev.torch.override {
      #   rocmSupport = true;
      # };

      # torchcodec = pyprev.torchcodec.overrideAttrs (old: {
      #   nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      #     pkgs.rocmPackages.clr
      #     pkgs.rocmPackages.hipcc
      #   ];
      #   buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.rocmPackages.clr ];
      #
      #   # We force CMake to find HIP before Torch so the 'hip::amdhip64' target is defined
      #   postPatch = (old.postPatch or "") + ''
      #     substituteInPlace src/torchcodec/_core/CMakeLists.txt \
      #       --replace-fail "find_package(Torch REQUIRED)" "find_package(HIP REQUIRED)\nfind_package(Torch REQUIRED)"
      #   '';
      # });

      # hyperpyyaml =
      #   let
      #     ruamel = pyprev.ruamel-yaml.overrideAttrs (old: {
      #       inherit (stable.python3Packages.ruamel-yaml) version src;
      #     });
      #   in
      #   pyprev.hyperpyyaml.override {
      #     ruamel-yaml = ruamel;
      #   };
      #
      whisperx =
        (pyprev.whisperx.override {
          ctranslate2-cpp = ctranslate2-cpp;
          # ctranslate2 = pyfinal.ctranslate2;
          # faster-whisper = pyfinal.faster-whisper;
        }).overrideAttrs
          (old: {
            postPatch = (old.postPatch or "") + ''
              # Relax strict version pins that clash with newer Nixpkgs
              substituteInPlace pyproject.toml \
                    --replace-fail 'huggingface-hub<1.0.0' 'huggingface-hub>=0.23.0,<2.0.0' \
            '';
          });
    };
  };

in
pkgs.mkShell {
  packages = [
    # ctranslate2-cpp
    (python.withPackages (ps: [
      ps.whisperx
      # ps.faster-whisper
      ps.ctranslate2
      # ps.hyperpyyaml
    ]))
  ];

  shellHook = ''
    # 1. Setup ROCm runtime paths
    # export LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.rocmPackages.clr}/lib:${ctranslate2-cpp}/lib:$LD_LIBRARY_PATH"

    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ]
    }:${ctranslate2-cpp}/lib:$LD_LIBRARY_PATH"
    # 2. Setup a venv if it doesn't exist
    if [ ! -d ".venv" ]; then
      python -m venv .venv --system-site-packages
    fi
    source .venv/bin/activate

    echo "Hybrid Shell Ready. Nix-built CTranslate2 is active."
  '';
}
