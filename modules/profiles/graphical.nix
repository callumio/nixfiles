{ config, inputs, ... }:
{
  flake.nixosModules.profile-graphical = {
    imports = [
      config.flake.nixosModules.profile-base
      config.flake.nixosModules.gpg-pinentry-wayland
      inputs.stylix.nixosModules.stylix
    ];
  };
}
