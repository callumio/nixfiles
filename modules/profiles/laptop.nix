{ config, ... }:
{
  flake.nixosModules.profile-laptop = {
    imports = with config.flake.nixosModules; [
      profile-graphical
    ];
  };
}
