{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.yomitan;

  yomitan-api-pkg = pkgs.stdenv.mkDerivation {
    pname = "yomitan-api";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "yomidevs";
      repo = "yomitan-api";
      rev = "02f52d61e9ee1dc40dc4bb4d6e33be4d4c3dc3ae";
      hash = "sha256-Z98kYPrbQYoSF4gesnHgsyQqYw0pEDcoAjc6zaud9pI=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [ pkgs.python3 ];

    # Patching source code to use a writable directory for lock/log files
    postPatch = ''
      substituteInPlace yomitan_api.py \
        --replace 'script_path = os.path.realpath(os.path.dirname(__file__))' \
                  'script_path = os.path.expanduser("~/.cache/yomitan-api"); os.makedirs(script_path, exist_ok=True)'
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/yomitan-api
      cp yomitan_api.py $out/share/yomitan-api/

      # Create binary wrapper
      makeWrapper ${pkgs.python3}/bin/python3 $out/bin/yomitan-api \
        --add-flags "-u $out/share/yomitan-api/yomitan_api.py"
    '';
  };

  # Native messaging manifest for Brave/Chrome
  manifest = {
    name = "yomitan_api";
    description = "Yomitan API";
    path = "${yomitan-api-pkg}/bin/yomitan-api";
    type = "stdio";
    allowed_origins = [ "chrome-extension://likgccmbimhjbgkjambclfkhldnlhbnn/" ];
  };

in
{
  options.services.yomitan = {
    enableApi = mkEnableOption "Yomitan API";
    braveApiIntegration = mkEnableOption "Brave integration via native messaging";
  };

  config = mkIf cfg.enableApi {
    home.packages = [ yomitan-api-pkg ];

    # Brave Native Messaging Host configuration
    home.file.".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/yomitan_api.json" =
      mkIf cfg.braveApiIntegration
        {
          text = builtins.toJSON manifest;
        };
  };
}
