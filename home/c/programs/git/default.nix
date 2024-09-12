{...}: {
  programs.git = {
    enable = true;

    userName = "Callum Leslie";
    userEmail = "git@cleslie.uk";
    signing.key = "483E476D02ED580C";
    signing.signByDefault = true;

    ignores = [".direnv/"];

    includes = [
      {
        condition = "gitdir:~/repos/projects.cs.nott.ac.uk/";
        contents = {
          user = {
            email = "psycl6@nottingham.ac.uk";
            signingKey = "483E476D02ED580C";
          };
          credential = {helper = "store";};
        };
      }
    ];

    extraConfig = {
      core = {
        longpaths = true;
        autocrlf = false;
      };

      init = {defaultBranch = "main";};

      push = {autoSetupRemote = true;};
      ghq = {root = "~/repos";};
    };

    diff-so-fancy.enable = true;
  };
}
