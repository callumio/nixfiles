{
  config,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  c.services.mesh = {
    enable = true;
    exitNode = false;
    keyFile = config.age.secrets.mesh-conf-cleslie.path;
  };
  c.services.remote-deploy = {
    enable = false;
    keys = config.keys.c;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.c = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd" "dialout"];
    openssh.authorizedKeys.keys = config.keys.c;
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  nix.settings.trusted-users = ["c"];

  environment.systemPackages = with pkgs; [
    vim
    adwaita-icon-theme
    apple-cursor
    wget
    pinentry
    fzf
    nil
    killall
    gcc
    pkg-config
    sbctl
    nish
    nsbm
  ];

  environment = {
    variables = {EDITOR = "nvim";};
    sessionVariables = {NIXOS_OZONE_WL = "1";};

    shells = with pkgs; [fish];
  };

  fonts.packages = with pkgs; [nerdfonts meslo-lgs-nf];
}
