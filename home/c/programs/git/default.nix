{...}: {
  programs.git = {
    enable = true;

    userName = "Callum Leslie";
    userEmail = "git@cleslie.uk";
    signing.key = "03B01F427831BCFD!";
    signing.signByDefault = true;

    ignores = [".direnv/"];

    includes = [
      {
        condition = "gitdir:~/repos/projects.cs.nott.ac.uk/";
        contents = {
          user = {
            email = "psycl6@nottingham.ac.uk";
            signingKey = "14861F1282EFB5C8!";
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

    delta.enable = true;
  };
}
