let
  exportModules = args:
    builtins.listToAttrs (map (arg: {
        name = let
          str = baseNameOf arg;
          suffix = ".nix";
          sufLen = builtins.stringLength suffix;
          sLen = builtins.stringLength str;
        in
          if sufLen <= sLen && suffix == builtins.substring (sLen - sufLen) sufLen str
          then builtins.substring 0 (sLen - sufLen) str
          else str;

        value = import arg;
      })
      args);

  nixosModules = exportModules [
    ./nix.nix
    ./pinentry-fix.nix
    ./hm.nix
    ./boot.nix
    ./keys.nix
    ./deploy.nix
    ./tailscale.nix
    ./secret.nix
  ];
  homeManagerModules =
    exportModules [
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
