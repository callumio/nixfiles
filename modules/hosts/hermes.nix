{ config, inputs, ... }:
{
  flake.nixosConfigurations.hermes = config.flake.lib.mkHost {
    modules = [
      config.flake.nixosModules.profile-server
      inputs.nocodb.nixosModules.nocodb
      inputs.copyparty.nixosModules.default
      ../../hosts/hermes
    ];
    overlays = [ inputs.copyparty.overlays.default ];
  };
}
