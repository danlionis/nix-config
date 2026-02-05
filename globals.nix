{ ... }:
{
  globals = {
    domains = rec {
      lionis = "lionis.net";
      start = "start.${lionis}";
      auth = "auth.${lionis}";
      paperless = "paper.${lionis}";
      git = "git.${lionis}";
      backup = "kronos.ts.lionis.net";
    };
  };
}
