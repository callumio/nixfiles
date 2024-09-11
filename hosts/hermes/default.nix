{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./fail2ban.nix
    ./containers.nix
    ./networking.nix
    ./ssh.nix
    ./media.nix
    ./headscale.nix
    ./forgejo.nix
  ];
}
