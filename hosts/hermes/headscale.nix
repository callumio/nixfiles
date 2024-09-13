{config, ...}: let
  domain = "mesh.cleslie.uk";
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      settings = {
        server_url = "https://${domain}";
        dns_config = {base_domain = "cleslie.uk";};

        ip_prefixes = "100.64.0.0/10";
      };
    };
    cloudflare-dyndns.domains = [domain];
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy localhost:${toString config.services.headscale.port}
    '';
  };
}
