{inputs, ...}: {
  home-manager = {
    sharedModules = [
      {
        stylix.targets = {
          fish.enable = false;
        };
      }
    ];
    users.c = import ../../home;
    extraSpecialArgs = {inherit inputs;};
  };
}
