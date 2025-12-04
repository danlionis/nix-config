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
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
