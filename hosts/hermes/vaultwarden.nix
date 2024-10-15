{config, ...}: let
  domain = "vaultwarden.cleslie.uk";
in {
  services = {
    cloudflare-dyndns.domains = [domain];
    vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      config = {
        DOMAIN = "https://${domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
      environmentFile = "${config.age.secrets.vaultwarden-env.path}";
    };

    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy localhost:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  age.secrets."vaultwarden-env" = {
    file = ../../secrets/vaultwarden-env.age;
  };
}
