{
  pkgs,
  config,
  ...
}: let
  mediaDir = "/var/lib/media";
in {
  users = {
    groups.multimedia = {gid = 994;};
    users."root".extraGroups = ["multimedia"];
    users."media".extraGroups = ["multimedia"];
  };

  systemd.tmpfiles.rules = [
    "d ${mediaDir} 0775 - multimedia - -"

    "d ${mediaDir}/torrents 0775 - multimedia -"
    "d ${mediaDir}/torrents/Downloads 0775 - multimedia -"

    "d ${mediaDir}/usenet 0775 - multimedia -"
    "d ${mediaDir}/usenet/Downloads 0775 - multimedia -"
    "d ${mediaDir}/usenet/Done 0775 - multimedia -"

    "d ${mediaDir}/library/Movies 0775 - multimedia - -"
    "d ${mediaDir}/library/TV 0775 - multimedia - -"
    "d ${mediaDir}/library/Music 0775 - multimedia - -"

    "d /var/lib/tdarr 0775 - multimedia - "
    "d /var/lib/tdarr/server 0775 - multimedia - "
    "d /var/lib/tdarr/configs 0775 - multimedia - "
    "d /var/lib/tdarr/logs 0775 - multimedia - "
  ];

  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  # };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      unstable.vpl-gpu-rt # QSV on 11th gen or newer
      #intel-media-sdk # QSV up to 11th gen
    ];
  };

  services = {
    caddy = {
      enable = true;
      email = "acme@cleslie.uk";
      virtualHosts = {
        "media.cleslie.uk".extraConfig = ''
          redir /radarr /radarr/
          redir /sonarr /sonarr/
          redir /lidarr /lidarr/
          redir /bazarr /bazarr/
          redir /prowlarr /prowlarr/
          redir /tdarr /tdarr/
          redir /deluge /deluge/
          reverse_proxy /radarr/* 127.0.0.1:7878
          reverse_proxy /sonarr/* 127.0.0.1:8989
          reverse_proxy /lidarr/* 127.0.0.1:8686
          reverse_proxy /bazarr/* 127.0.0.1:6767
          reverse_proxy /prowlarr/* 127.0.0.1:9696
          reverse_proxy /tdarr/* 127.0.0.1:8265
          route /deluge/* {
          	uri strip_prefix deluge
          	reverse_proxy 127.0.0.1:8112 {
          		header_up X-Real-IP {remote}
          		header_up X-Deluge-Base "/deluge"

          	}
          }
        '';
        "watch.cleslie.uk".extraConfig = ''
          reverse_proxy http://localhost:8096
        '';
        "request.cleslie.uk".extraConfig = ''
          reverse_proxy http://localhost:5055
        '';
      };
    };

    cloudflare-dyndns.domains = ["media.cleslie.uk" "watch.cleslie.uk" "request.cleslie.uk"];

    jellyfin = {
      enable = true;
      package = pkgs.jellyfin;
      group = "multimedia";
      openFirewall = false;
    };
    jellyseerr = {
      enable = true;
      openFirewall = false;
    };
    sonarr = {
      enable = true;
      group = "multimedia";
      openFirewall = false;
    };
    radarr = {
      enable = true;
      group = "multimedia";
      openFirewall = false;
    };
    bazarr = {
      enable = true;
      group = "multimedia";
      openFirewall = false;
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
    };
    deluge = {
      enable = true;
      group = "multimedia";
      web.enable = true;
      web.openFirewall = false;
      dataDir = "${mediaDir}/torrents";
      declarative = true;
      config = {
        enabled_plugins = ["Label"];
        outgoing_interface = "wg1";
        allow_remote = true;
        openFirewall = false;
        sequential_download = true;
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-auth";
        text = ''
          localclient::10
        '';
      };
    };
  };
}
