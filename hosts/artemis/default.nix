{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./containers.nix
    ./networking.nix
    ./ssh.nix
    ./programs.nix
    ./home.nix
    ./styling.nix
  ];
}
