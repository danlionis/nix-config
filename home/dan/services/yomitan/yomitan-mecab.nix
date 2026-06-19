{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.yomitan;

  unidic-mecab = pkgs.stdenv.mkDerivation {
    pname = "unidic-mecab-bin";
    version = "unidic-mecab-translate";

    src = pkgs.fetchzip {
      url = "https://github.com/yomidevs/yomitan-mecab-installer/releases/download/unidic/unidic.zip";
      sha256 = "sha256-KvMr8hsjwoaKlzC96v17FN99IYjmSL0fgwTlkcuOPHU=";
    };

    installPhase = ''
      mkdir -p $out/unidic-mecab-translate
      cp -r . $out/unidic-mecab-translate
    '';
  };

  mecabrc = pkgs.writeText "mecabrc" "";

  yomitan-mecab-pkg = pkgs.stdenv.mkDerivation {
    pname = "yomitan-mecab";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "yomidevs";
      repo = "yomitan-mecab-installer";
      rev = "4e6532163134ee0471fcf31d94092ff17c870eca";
      hash = "sha256-FpyfphZdE8rmv2aD5ajGxz9fkx6zQU7BUx3prgIpDAw=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [
      pkgs.python3
      pkgs.mecab
    ];

    postPatch = ''
      ls -la
      # Patch the script to use absolute paths for the mecab binary and mecabrc file
      substituteInPlace mecab.py \
        --replace "return 'mecab'" "return '${pkgs.mecab}/bin/mecab'" \
        --replace "os.path.join(DIR, 'mecabrc')" "'${mecabrc}'"
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/yomitan-mecab
      cp mecab.py $out/share/yomitan-mecab/

      # inside yomitan-mecab-pkg installPhase
      mkdir -p $out/share/yomitan-mecab/data
      # Use the exact name with the star emoji
      ln -s ${unidic-mecab}/unidic-mecab-translate "$out/share/yomitan-mecab/data/unidic-mecab-translate"

      makeWrapper ${pkgs.python3}/bin/python3 $out/bin/yomitan-mecab \
        --add-flags "-u $out/share/yomitan-mecab/mecab.py"
    '';
  };

  manifest = {
    name = "yomitan_mecab";
    description = "MeCab for Yomitan (UniDic Binary)";
    path = "${yomitan-mecab-pkg}/bin/yomitan-mecab";
    type = "stdio";
    allowed_origins = [
      "chrome-extension://likgccmbimhjbgkjambclfkhldnlhbnn/"
    ];
  };

in
{
  options.services.yomitan = {
    enableMecab = mkEnableOption "Yomitan MeCab host";
    braveMecabIntegration = mkEnableOption "Brave integration via native messaging";
  };

  config = mkIf cfg.enableMecab {
    home.packages = [ yomitan-mecab-pkg ];

    # Brave Native Messaging Host configuration
    home.file.".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/yomitan_mecab.json" =
      mkIf cfg.braveMecabIntegration
        {
          text = builtins.toJSON manifest;
        };
  };
}
