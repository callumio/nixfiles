{...}: {
  imports = [
    ./hypr
    ./waybar
    ./git
    ./fish
    ./jj
    ./rofi
    ./rbw
    ./firefox
    ./tmux
    ./alacritty
    ./direnv
  ];

  programs = {
    gpg.enable = true;
  };
}
