{lib, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Callum Leslie";
        email = "git@cleslie.uk";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
      };

      ui = {
        pager = "delta";
        diff-formatter = ":git";
      };
      git = {
        private-commits = "description(glob:'wip:*') | description(glob:'private:*') | description(glob:'fixup*')";
      };

      "--scope" = [
        {
          "--when".repositories = ["~/repos/projects.cs.nott.ac.uk"];
          user = {
            email = "psycl6@nottingham.ac.uk";
          };
        }
        {
          "--when".commands = ["status"];
          ui.paginate = "never";
        }
      ];
    };
  };
}
