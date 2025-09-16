{config, ...}: let
  domain = "files.cleslie.uk";
in {
  services = {
    cloudflare-dyndns.domains = [domain];
    copyparty = {
      enable = true;
      settings = {
        i = "127.0.0.1";
        p = [3210];
      };
      accounts = {
        c.passwordFile = config.age.secrets.copyparty-c.path;
      };
      volumes = {
        "/media" = {
          path = "/var/lib/media/library";
          access = {
            rw = ["c"];
          };
        };
        "/paperless" = {
          path = "/var/lib/media/library";
          access = {
            rw = ["c"];
          };
        };
      };
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy http://127.0.0.1:3210
    '';
  };
  age.secrets."copyparty-c" = {
    file = ../../secrets/copyparty-c.age;
    mode = "400";
    owner = "copyparty";
  };
}
