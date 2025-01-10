{
  inputs,
  pkgs,
  ...
}: {
  imports = [./programs ./services];

  programs.home-manager.enable = true;
  services.trayscale.enable = true;

  home = {
    username = "c";
    homeDirectory = "/home/c";
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
  };
  gtk.enable = true;
  gtk.iconTheme = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
  };

  home.packages = with pkgs; [
    apple-cursor
    # TODO: sort this out
    adwaita-icon-theme
    networkmanagerapplet
    libsecret
    bitwarden
    #betterbird
    wl-clipboard
    discord
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
    wireshark
    inputs.nixvim.packages."x86_64-linux".default # nixvim
  ];

  home.stateVersion = "24.05";
}
