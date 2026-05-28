final: prev: {
  ctranslate2-rocm = final.callPackage ./ctranslate2-rocm.nix {
    withROCm = true;
    rocmPackages = final.rocmPackages;
  };

  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (pyfinal: pyprev: {
      ctranslate2-rocm = pyprev.ctranslate2.override {
        ctranslate2-cpp = final.ctranslate2-rocm;
      };

      faster-whisper-rocm = pyprev.faster-whisper.override {
        ctranslate2 = pyfinal.ctranslate2-rocm;
      };

      whisperx-rocm =
        ((pyprev.whisperx or pyprev.whisperX).override {
          ctranslate2 = pyfinal.ctranslate2-rocm;
          ctranslate2-cpp = final.ctranslate2-rocm;
          faster-whisper = pyfinal.faster-whisper-rocm;
        }).overrideAttrs
          (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/whisperx \
                --set CT2_CUDA_ALLOCATOR cub_caching
            '';
          });
    })
  ];

  whisperx-rocm = final.python3.pkgs.whisperx-rocm;
}
