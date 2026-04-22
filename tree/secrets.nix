{...}: {
  flake.nixosModules.secrets = {...}: {
    imports = [../secrets/secrets-configuration.nix];
  };
}
