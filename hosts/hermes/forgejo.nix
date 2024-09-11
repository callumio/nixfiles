{
  lib,
  config,
  ...
}: let
  domain = "git.cleslie.uk";
in {
  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";
      settings = {
        server = {
          #DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          HTTP_PORT = 3000;
          SSH_PORT = builtins.head config.services.openssh.ports;
        };
        service.DISABLE_REGISTRATION = true;
      };
    };

    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}
    '';
  };

  systemd.services.forgejo.preStart = ''
    admin="${lib.getExe config.services.forgejo.package} admin user"
    $admin create --admin --email "git@cleslie.uk" --username cleslie --password "$(tr -d '\n' < ${config.age.secrets.forgejo-password.path})" || true
    # $admin change-password --username cleslie --password "$(tr -d '\n' < ${config.age.secrets.forgejo-password.path})" || true
  '';

  age.secrets."forgejo-password" = {
    file = ../../secrets/forgejo-password.age;
    mode = "400";
    owner = "forgejo";
  };
}
