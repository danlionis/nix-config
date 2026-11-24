{ pkgs, inputs, ... }:
let
  sbx = inputs.agent-sandbox.lib.${pkgs.system};
  codex-sandboxed = sbx.mkSandbox {
    pkg = pkgs.codex;
    binName = "codex";
    outName = "codex"; # or whatever alias you'd like
    allowedPackages = sbx.commonTools;
    # Uncomment to always work in one directory, wherever you launch from:
    # workspaceDir = "$HOME/projects/my-project";
    rwDirs = [ "$HOME/.codex" ];
    rwFiles = [ ];
    # For git identity, uncomment to bind your host gitconfig (see README):
    # roFiles = [ "$HOME/.config/git/config" ];
    env = {
      # Pass secrets as shell variable references (e.g. "$TOKEN"), not
      # via builtins.getEnv, so they expand at runtime and stay out of
      # the /nix/store.
      # OPENAI_API_KEY = "$OPENAI_API_KEY";
      # GITHUB_TOKEN = "$GITHUB_TOKEN";
      CODEX_HOME = "$HOME/.codex";
    };
    allowedDomains = {
      "api.openai.com" = "*";
      "chatgpt.com" = "*";
      "github.com/openai" = "*";
      "files.openai.com" = [
        "GET"
        "HEAD"
      ];
      "raw.githubusercontent.com" = [
        "GET"
        "HEAD"
      ];
      "api.github.com" = [
        "GET"
        "HEAD"
      ];
      "github.com" = [
        "GET"
        "HEAD"
      ];
      "codeload.github.com" = [
        "GET"
        "HEAD"
      ];
    };
  };
in
{
  home.packages = [ codex-sandboxed ];
}
