{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs.self.nixosModules) keys;
in {
  c.services.mesh = {
    enable = true;
    exitNode = false;
    keyFile = config.age.secrets.mesh-conf-cleslie.path;
  };
  c.services.remote-deploy = {
    enable = false;
    keys = keys.c;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.c = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd" "dialout"];
    openssh.authorizedKeys.keys = keys.c;
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  nix.settings.trusted-users = ["c"];

  environment.systemPackages = with pkgs; [
    vim
    gnome.adwaita-icon-theme
    wget
    fzf
    nil
    killall
    gcc
    pkg-config
  ];

  environment = {
    variables = {EDITOR = "nvim";};
    sessionVariables = {NIXOS_OZONE_WL = "1";};

    shells = with pkgs; [fish];

    # etc."greetd/environments".text = ''
    #   hyprland
    # '';
  };
  fonts.packages = with pkgs; [nerdfonts meslo-lgs-nf];
}
