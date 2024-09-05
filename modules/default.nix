{utils, ...}: let
  nixosModules = utils.lib.exportModules [
    ./nix.nix
    ./pinentry-fix.nix
    ./hm.nix
    ./boot.nix
    ./keys.nix
    ./deploy.nix
    ./tailscale.nix
    ./secret.nix
  ];
  homeManagerModules = utils.lib.exportModules [
    ./trayscale.nix
  ];
  sharedModules = with nixosModules; [
    pinentry-fix
    nix
    hm
    boot
    keys
    deploy
    tailscale
    secret
  ];
in {
  inherit nixosModules homeManagerModules sharedModules;
}
