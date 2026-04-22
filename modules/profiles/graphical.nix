{ config, ... }:
{
  flake.nixosModules.profile-graphical = {
    imports = [
      config.flake.nixosmodules.profile-base
      config.flake.nixosModules.pinentry-fix-wayland
      inputs.stylix.nixosModules.stylix
    ];
  };
}
