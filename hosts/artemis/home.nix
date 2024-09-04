{inputs, ...}: {
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};
  home-manager = {
    sharedModules = [
      {
        stylix.targets = {
          fish.enable = false;
        };
      }
      inputs.self.homeManagerModules.trayscale
    ];
    users.c = import ../../home;
    extraSpecialArgs = {inherit inputs;};
  };
}
