{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Dan Lionis";
    };
    ignores = [
      ".direnv"
      ".envrc"
      "result"
    ];

    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
