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
  gtk.enable = true;
  gtk.iconTheme = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
  };

  home.packages = with pkgs; [
    # TODO: sort this out
    gnome.adwaita-icon-theme
    networkmanagerapplet
    libsecret
    bitwarden
    betterbird
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
    inputs.nixvim.packages."x86_64-linux".default # nixvim
  ];

  home.stateVersion = "24.05";
}
