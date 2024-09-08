{pkgs}: let
  name = "tmux-sessionizer";
  runtimeInputs = [pkgs.tmux pkgs.ghq pkgs.fzf];
  text = builtins.readFile ./tmux-sessionizer.sh;
in
  pkgs.writeShellApplication {
    inherit name runtimeInputs text;
  }
