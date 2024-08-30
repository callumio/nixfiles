{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "Callum Leslie";
    userEmail = "git@cleslie.uk";
    signing.key = "D382C4AFEECEAA90";
    signing.signByDefault = true;

    ignores = [".direnv/"];

    includes = [
      {
        condition = "gitdir:~/repos/projects.cs.nott.ac.uk/";
        contents = {
          user = {
            email = "psycl6@nottingham.ac.uk";
            signingKey = "5A944DF89B6F65AC";
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
