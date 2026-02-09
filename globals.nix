{ ... }:
{
  globals = {
    domains = rec {
      lionis = "lionis.net";
      start = "start.${lionis}";
      auth = "auth.${lionis}";
      paperless = "paper.${lionis}";
      git = "git.${lionis}";
      linkding = "links.lionis.net";
      backup = "kronos.ts.lionis.net";
      actualbudget = "budget.${lionis}";
    };
  };
}
