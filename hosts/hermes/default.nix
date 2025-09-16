{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./copyparty.nix
    ./ddns.nix
    ./quassel.nix
    ./fail2ban.nix
    ./containers.nix
    ./n8n.nix
    ./networking.nix
    ./nocodb.nix
    ./ssh.nix
    ./media.nix
    ./headscale.nix
    ./forgejo.nix
    ./vaultwarden.nix
  ];
}
