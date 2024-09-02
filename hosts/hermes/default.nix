{inputs}: {
  modules = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./fail2ban.nix
    ./containers.nix
    ./networking.nix
    ./ssh.nix
    ./media.nix
    ./headscale.nix
  ];
  extraArgs = {};
  specialArgs = {};
  system = "x86_64-linux";
  channelName = "unstable";
}
