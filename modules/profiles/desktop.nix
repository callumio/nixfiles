{ config, ... }:
{
  flake.nixosModules.profile-desktop = {
    imports = with config.flake.nixosModules; [
      profile-graphical
    ];
  };
}
