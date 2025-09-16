{pkgs, ...}: let
  domain = "automation.cleslie.uk";
in {
  services = {
    cloudflare-dyndns.domains = [domain];
    n8n = {
      enable = true;
      webhookUrl = "https://" + domain + "/";
      settings = {
        port = 5678;
      };
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy http://127.0.0.1:5678
    '';
  };
  environment.systemPackages = with pkgs; [mupdf-headless];
}
