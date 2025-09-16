_: let
  domain = "hub.cleslie.uk";
in {
  services = {
    cloudflare-dyndns.domains = [domain];
    nocodb = {
      enable = true;
      environment = {
        NC_PUBLIC_URL = "https://" + domain;
        #NC_INVITE_ONLY_SIGNUP = 1;
        PORT = "4690";
      };
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy http://127.0.0.1:4690
    '';
  };
}
