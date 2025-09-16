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
      "--scope" = [
        {
          "--when".repositories = ["~/repos/projects.cs.nott.ac.uk"];
          user = {
            email = "psycl6@nottingham.ac.uk";
          };
        }
      ];
    };
  };
}
