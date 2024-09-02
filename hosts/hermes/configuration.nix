{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs.self.nixosModules) keys;
in {
  c.services.mesh = {
    enable = true;
    exitNode = true;
    keyFile = config.age.secrets.mesh-conf-infra.path;
  };

  c.services.remote-deploy = {
    enable = true;
    host = "media.cleslie.uk";
    port = 62480;
    keys = keys.c;
    buildOn = "local";
  };

  time.timeZone = "Europe/London";

  users.users.media = {
    isNormalUser = true;
    extraGroups = ["wheel" "multimedia"];
    openssh.authorizedKeys.keys = keys.c;
    packages = with pkgs; [
      tree
      nixvim
    ];
  };

  nix.settings.trusted-users = ["media"];

  environment.systemPackages = with pkgs; [
    wget
    tree
  ];
}
