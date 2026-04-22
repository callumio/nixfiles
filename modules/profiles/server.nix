{ config, ... }:
{
  flake.nixosModules.profile-server = {
    imports = with config.flake.nixosModules; [
      profile-base
      deploy
    ];
  };
}
