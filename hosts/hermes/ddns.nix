{config, ...}: {
  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    ipv6 = false;
    proxied = false;
    deleteMissing = false;
    domains = [];
    apiTokenFile = config.age.secrets.cloudflare-api.path;
  };
  # services.cloudflare-dyndns.domains = [];
  age.secrets."cloudflare-api".file = ../../secrets/cloudflare-api.age;
}
