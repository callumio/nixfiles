{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./ddns.nix
    ./quassel.nix
    ./fail2ban.nix
    ./containers.nix
    ./networking.nix
    ./ssh.nix
    ./media.nix
    ./headscale.nix
    ./forgejo.nix
    ./vaultwarden.nix
  ];
}
