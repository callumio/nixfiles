{ config, ... }:
{
  flake.nixosConfigurations.artemis = config.flake.lib.mkHost {
    modules = [
      config.flake.nixosModules.profile-laptop
      ../../hosts/artemis
    ];
  };
}
