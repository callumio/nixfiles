{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {TERM = "xterm-256color";};
    };
  };
}
