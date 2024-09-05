{
  inputs,
  utils,
  mods,
  self,
  ...
}: let
  sharedModules = [inputs.home-manager.nixosModules.home-manager inputs.stylix.nixosModules.stylix inputs.agenix.nixosModules.default] ++ mods.sharedModules;
  artemis = import ./artemis {inherit inputs sharedModules;};
  hermes = import ./hermes {inherit inputs sharedModules;};
in {
  hosts = [artemis hermes];
}
