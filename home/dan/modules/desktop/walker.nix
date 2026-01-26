{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  elephant = inputs.elephant.packages.${pkgs.stdenv.system}.elephant-with-providers;
  walker = inputs.walker.packages.${pkgs.stdenv.system}.walker;
  providers = [
    "desktopapplications"
    "files"
    "clipboard"
    "runner"
    "symbols"
    "calc"
    "menus"
    "providerlist"
    # "websearch"
    # "todo"
    "unicode"
    # "bluetooth"
  ];
in
{
  # i want to configure the dotfiles in the dotfiles repo, so we dont enable the modules but only start the services
  home.packages = [
    elephant
    walker
  ];

  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant launcher backend";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "simple";
      ExecStart = "${elephant}/bin/elephant";
      Restart = "on-failure";
      RestartSec = 1;

      # Clean up socket on stop
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/elephant.sock";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Install providers to user config
  xdg.configFile = # Generate provider files
    builtins.listToAttrs (
      map (
        provider:
        lib.nameValuePair "elephant/providers/${provider}.so" {
          source = "${elephant}/lib/elephant/providers/${provider}.so";
        }
      ) providers
    );

  systemd.user.services.walker = {
    Unit = {
      Description = "Walker - Application Runner";
      ConditionEnvironment = "WAYLAND_DISPLAY";
      After = [
        "graphical-session.target"
        "elephant.service"
      ];
      Requires = [ "elephant.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
