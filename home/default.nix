{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./programs ./services];

  programs.home-manager.enable = true;

  home = {
    username = "c";
    homeDirectory = "/home/c";
  };

  home.packages = with pkgs; [
    libsecret
    bitwarden
    betterbird
    wl-clipboard
    (discord.override {
      withOpenASAR = true;
    })
    brightnessctl
    playerctl
    pwvucontrol
    tldr
    grc
    fd
    rofi-rbw-wayland
    wtype
    mullvad-vpn
    spotify
    gnumake
    delta
    slurp
    grim
    clang-tools
    clang
    ghq
    gst
    udiskie
    rustup
    ripgrep
    zig
    ghc
    xh
    unzip
    just
    inputs.nixvim.packages."x86_64-linux".default # nixvim
  ];

  home.stateVersion = "24.05";
}
