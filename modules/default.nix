{utils}: let
  nixosModules = utils.lib.exportModules [
    ./nix.nix
    ./hm.nix
    ./boot.nix
    ./deploy.nix
    ./keys.nix
    ./secret.nix
  ];
  sharedModules = with nixosModules; [
    nix
    hm
    boot
    deploy
    secret
  ];
in {inherit nixosModules sharedModules;}
