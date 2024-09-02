{utils}: let
  nixosModules = utils.lib.exportModules [
    ./nix.nix
    ./hm.nix
    ./boot.nix
    ./deploy.nix
    ./keys.nix
    ./secret.nix
    ./tailscale.nix
  ];
  sharedModules = with nixosModules; [
    nix
    hm
    boot
    deploy
    tailscale
    secret
  ];
in {inherit nixosModules sharedModules;}
