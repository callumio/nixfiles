{ inputs, config, ... }:
{
  flake.nixosModules.profile-base = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.agenix.nixosModules.default
      config.flake.nixosModules.nix-config
      config.flake.nixosModules.boot
      config.flake.nixosModules.keys
      config.flake.nixosModules.hm
      config.flake.nixosModules.secrets
      config.flake.nixosModules.tailscale
    ];
  };
}
