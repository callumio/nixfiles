{...}: {
  imports = [
    ./hypr
    ./waybar
    ./git
    ./fish
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
