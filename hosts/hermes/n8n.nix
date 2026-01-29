{pkgs, ...}: let
  domain = "automation.cleslie.uk";
in {
  services = {
    cloudflare-dyndns.domains = [domain];
    n8n = {
      enable = true;
      environment = {
        PORT = "5678";
        WEBHOOK_URL = "https://" + domain + "/";
      };
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy http://127.0.0.1:5678
    '';
  };
  environment.systemPackages = with pkgs; [mupdf-headless];
}
