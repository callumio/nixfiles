{
  modules = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./containers.nix
    ./networking.nix
    ./ssh.nix
    ./programs.nix
    ./home.nix
    ./styling.nix
  ];
  extraArgs = {};
  specialArgs = {};
  system = "x86_64-linux";
}
