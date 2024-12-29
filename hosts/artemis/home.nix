{
  inputs,
  cLib,
  ...
}: {
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};
  home-manager = {
    sharedModules = [
      {
        stylix.targets = {
          fish.enable = false;
          tmux.enable = false;
        };
      }
      #inputs.self.homeManagerModules.trayscale
    ];
    users.c = import ../../home/c;
    extraSpecialArgs = {inherit inputs cLib;};
  };
}
