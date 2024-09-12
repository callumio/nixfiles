{
  pkgs,
  cLib,
  ...
}: let
  mkFishPlug = pkg: {
    name = pkg.pname;
    inherit (pkg) src;
  };
  tmux = cLib.getProgFor pkgs "tmux";
in {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting
      trap __trap_exit_tmux EXIT
    '';

    # TODO: dont use this directly
    shellAliases = {v = "nvim";};

    functions = {
      __trap_exit_tmux = {
        body = ''
          test (${tmux} list-windows | wc -l) = 1 || exit
          test (${tmux} list-panes | wc -l) = 1 || exit
          ${tmux} switch-client -t main
        '';
      };
    };

    plugins = with pkgs.fishPlugins; [
      (mkFishPlug z)
      (mkFishPlug hydro)
      (mkFishPlug sponge)
      (mkFishPlug grc)
      (mkFishPlug done)
      (mkFishPlug fzf-fish)
      (mkFishPlug git-abbr)
    ];
  };
}
