{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
      trap __trap_exit_tmux EXIT
    '';

    shellAliases = {v = "nvim";};

    functions = {
      __trap_exit_tmux = {
        body = ''
          test (tmux list-windows | wc -l) = 1 || exit
          test (tmux list-panes | wc -l) = 1 || exit
          tmux switch-client -t main
        '';
      };
    };

    plugins = with pkgs.fishPlugins; [
      {
        name = "z";
        inherit (z) src;
      }
      {
        name = "hydro";
        inherit (hydro) src;
      }
      {
        name = "sponge";
        inherit (sponge) src;
      }
      {
        name = "grc";
        inherit (grc) src;
      }
      {
        name = "done";
        inherit (done) src;
      }
      {
        name = "fzf-fish";
        inherit (fzf-fish) src;
      }
      {
        name = "forgit";
        inherit (forgit) src;
      }
    ];
  };
}
