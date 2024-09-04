{utils}: let
  nixosModules = utils.lib.exportModules [
    ./nix.nix
    ./pinentry-fix.nix
    ./hm.nix
    ./boot.nix
    ./deploy.nix
    ./keys.nix
    ./secret.nix
    ./tailscale.nix
  ];
  homeManagerModules = utils.lib.exportModules [
    ./trayscale.nix
  ];
  sharedModules = with nixosModules; [
    pinentry-fix
    nix
    hm
    boot
    deploy
    tailscale
    secret
  ];
in {
  inherit nixosModules homeManagerModules sharedModules;
}
