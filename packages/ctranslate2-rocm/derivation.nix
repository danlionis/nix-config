{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  rocmPackages,
  gpuArchs ? [ "gfx1101" ],
  symlinkJoin,
  pkg-config,

  withCUDA ? false,
  withCuDNN ? false,

  libretranslate,
  wyoming-faster-whisper,
}:

let
  # Use the ROCm-specific stdenv which is tuned for hipcc/clang
  stdenv' = rocmPackages.stdenv;

  rocmLibs = with rocmPackages; [
    clr
    hipblas
    hipcc
    miopen
    rocblas
    rocm-core
    rocm-device-libs
    rocm-runtime
    rocm-smi
    rocprim
    rocsolver
    rocsparse
    rocthrust
  ];

  # symlinkJoin is more reliable for merging the nested "cuda/" and "thrust/" directories
  rocmPath = symlinkJoin {
    name = "rocm-path-combined";
    paths = rocmLibs;
  };
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "ctranslate2-rocm";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "dapovoa";
    repo = "CTranslate2";
    # rev = "v${finalAttrs.version}";
    rev = "7dfa468368934499da16cf5d6823dcc14d4d4327";
    fetchSubmodules = true;
    # Ensure this hash is the one generated WITH submodules
    # hash = "sha256-hTJxJPzwHIuQLGIRFSfilqnN666m5JchOXxdmISWylc=";
    hash = "sha256-hI52qhpGLJqrcJrtJXLOj6FkQJbTXZQ+pQKn8OpRHAk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ rocmLibs;

  buildInputs = [
    llvmPackages.openmp
  ]
  ++ rocmLibs;

  env = {
    # MIOPEN_PATH = rocmPackages.miopen;
    ROCM_PATH = rocmPath;
    # HIP_PATH = rocmPath;
    # # CPATH helps the compiler find <cuda/__cccl_config> inside rocm-path/include
    # CPATH = "${rocmPath}/include";
    # LIBRARY_PATH = "${rocmPath}/lib";
    # CPLUS_INCLUDE_PATH = "${rocmPath}/include";
    # NIX_CFLAGS_COMPILE = "-D__HIP__=1";
  };

  postPatch = ''
    # Only patch if submodules were successfully fetched
    if [ -d third_party/cpu_features ]; then
      substituteInPlace third_party/cpu_features/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 3.0)' 'cmake_minimum_required(VERSION 3.10)' || true
    fi

    if [ -d third_party/ruy/third_party/cpuinfo/deps/clog ]; then
      substituteInPlace third_party/ruy/third_party/cpuinfo/deps/clog/CMakeLists.txt \
        --replace-fail 'CMAKE_MINIMUM_REQUIRED(VERSION 3.1 FATAL_ERROR)' 'CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)' || true
    fi

    # if [ -f third_party/cxxopts/include/cxxopts.hpp ]; then
    #   sed -e '1i #include <cstdint>' -i third_party/cxxopts/include/cxxopts.hpp || true
    # fi
  '';

  cmakeFlags = [
    (lib.cmakeFeature "OPENMP_RUNTIME" "COMP")
    (lib.cmakeBool "WITH_MKL" false)
    (lib.cmakeBool "WITH_OPENBLAS" false)
    (lib.cmakeBool "WITH_RUY" true)
    (lib.cmakeBool "WITH_DNNL" false)
    (lib.cmakeBool "ENABLE_CPU_DISPATCH" false)
    # Force Thrust to use the HIP backend
    (lib.cmakeFeature "THRUST_DEVICE_SYSTEM" "HIP")
    # Use the wrapped hipcc from the nix store
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${rocmPackages.clr}/bin/hipcc")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")

    (lib.cmakeBool "WITH_CUDA" false)
    (lib.cmakeBool "WITH_CUDNN" false)
    (lib.cmakeFeature "GPU_RUNTIME" "HIP")
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" (lib.concatStringsSep ";" gpuArchs))
    (lib.cmakeFeature "GPU_TARGETS" (lib.concatStringsSep ";" gpuArchs))
  ];

  meta = with lib; {
    description = "Fast inference engine for Transformer models (ROCm/HIP fork)";
    mainProgram = "ct2-translator";
    homepage = "https://github.com/dapovoa/CTranslate2";
    license = licenses.mit;
    platforms = platforms.linux;
  };

  passthru.tests = {
    inherit
      libretranslate
      wyoming-faster-whisper
      ;
  };

})
