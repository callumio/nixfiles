{
  config,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  c.services.mesh = {
    enable = true;
    exitNode = true;
    keyFile = config.age.secrets.mesh-conf-infra.path;
  };

  c.services.remote-deploy = {
    enable = true;
    host = "media.cleslie.uk";
    port = 62480;
    keys = config.keys.c;
    buildOn = "local";
  };

  time.timeZone = "Europe/London";

  users.users.media = {
    isNormalUser = true;
    extraGroups = ["wheel" "multimedia"];
    openssh.authorizedKeys.keys = config.keys.c;
    packages = with pkgs; [
      tree
      nvf
    ];
  };

  nix.settings.trusted-users = ["media"];

  environment.systemPackages = with pkgs; [
    wget
    tree
  ];
}
