{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  cmake,
  llvmPackages, # openmp
  withMkl ? false,
  mkl,
  symlinkJoin,
  withCUDA ? false,
  withCuDNN ? false,
  cudaPackages,
  withROCm ? config.rocmSupport,
  rocmPackages,
  # Enabling both withOneDNN and withOpenblas is broken
  # https://github.com/OpenNMT/CTranslate2/issues/1294
  withOneDNN ? withROCm,
  onednn,
  withOpenblas ? !withROCm,
  openblas,
  withRuy ? false,
  pkg-config,

  # passthru tests
  libretranslate,
  wyoming-faster-whisper,
}:

let
  stdenv' =
    if withCUDA then
      cudaPackages.backendStdenv
    else if withROCm then
      rocmPackages.stdenv
    else
      stdenv;

  # Default GPU targets from Dockerfile.rocm
  gpuTargets = [
    # "gfx1030"
    # "gfx1100"
    "gfx1101"
    # "gfx1102"
    # "gfx1150"
    # "gfx1151"
    # "gfx1200"
    # "gfx1201"
  ];

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
    hiprand
    rocrand
  ];

  rocmPath = symlinkJoin {
    name = "rocm-path-combined";
    paths = rocmLibs;
  };

in
stdenv'.mkDerivation (finalAttrs: {
  pname = "ctranslate2";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "OpenNMT";
    repo = "CTranslate2";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Dc67hYgZ0aAauZLrVp10jmP52AwdLIZw0iWR9YKHTtU=";
  };

  # Fix CMake 4 compatibility
  postPatch = ''
    substituteInPlace third_party/cpu_features/CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.10)'

    substituteInPlace third_party/ruy/third_party/cpuinfo/deps/clog/CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.1 FATAL_ERROR)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)'

    sed -e '1i #include <cstdint>' -i third_party/cxxopts/include/cxxopts.hpp
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    rocmPackages.llvm.clang
    rocmPackages.clr
  ]
  ++ rocmLibs
  ++ lib.optionals withCUDA [
    cudaPackages.cuda_nvcc
  ];

  preConfigure = lib.optionalString withROCm ''
    export ROCM_PATH=${rocmPath}
    export HIP_PATH=${rocmPath}
    # Help CMake find ROCm components
    export CMAKE_PREFIX_PATH="${rocmPackages.clr}:${rocmPackages.hipblas}:${rocmPackages.rocblas}:${rocmPackages.rocsolver}:$CMAKE_PREFIX_PATH"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_VERBOSE_MAKEFILE" "ON")
    (lib.cmakeFeature "OPENMP_RUNTIME" "COMP")
    (lib.cmakeBool "WITH_CUDA" withCUDA)
    (lib.cmakeBool "WITH_HIP" withROCm)
    (lib.cmakeBool "WITH_DNNL" withOneDNN)
    (lib.cmakeBool "WITH_OPENBLAS" withOpenblas)
    (lib.cmakeBool "WITH_RUY" withRuy)
    (lib.cmakeBool "WITH_MKL" withMkl)
  ]
  ++ lib.optionals withROCm [
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" (builtins.concatStringsSep ";" gpuTargets))
    (lib.cmakeFeature "GPU_TARGETS" (builtins.concatStringsSep ";" gpuTargets))
    (lib.cmakeFeature "CMAKE_C_COMPILER" "clang")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "clang++")
    # Recommended flags from Dockerfile (O3 is added by CMAKE_BUILD_TYPE=Release)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-msse4.1 -Wno-deprecated-literal-operator -Wno-unused-result")
    (lib.cmakeFeature "CMAKE_HIP_FLAGS" "-Wno-deprecated-literal-operator -Wno-unused-result")
    (lib.cmakeBool "ENABLE_CPU_DISPATCH" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "WITH_ACCELERATE" true)
  ];

  buildInputs =
    lib.optionals withMkl [
      mkl
    ]
    ++ lib.optionals withCUDA [
      cudaPackages.cuda_cccl
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
      cudaPackages.libcurand
    ]
    ++ lib.optionals (withCUDA && (cudaPackages ? cudnn)) [
      cudaPackages.cudnn
    ]
    ++ lib.optionals withROCm [
      rocmPackages.clr
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.rocsolver
      rocmPackages.hipcub
      rocmPackages.hiprand
      rocmPackages.rocprim
      rocmPackages.rocrand
      rocmPackages.rocthrust
      rocmPackages.llvm.openmp
    ]
    ++ rocmLibs
    ++ lib.optionals withOneDNN [
      onednn
    ]
    ++ lib.optionals withOpenblas [
      openblas
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      llvmPackages.openmp
    ];

  passthru.tests = {
    inherit
      libretranslate
      wyoming-faster-whisper
      ;
  };

  meta = {
    description = "Fast inference engine for Transformer models (ROCm enabled)";
    mainProgram = "ct2-translator";
    homepage = "https://github.com/OpenNMT/CTranslate2";
    changelog = "https://github.com/OpenNMT/CTranslate2/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    broken = !(withROCm -> (rocmPackages ? clr));
  };
})
