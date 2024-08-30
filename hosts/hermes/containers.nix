{
  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    oci-containers.backend = "podman";
    oci-containers.containers = {
      flaresolverr = {
        #image = "ghcr.io/flaresolverr/flaresolverr:latest";
        #image = "ghcr.io/flaresolverr/flaresolverr:pr-1282";
        image = "docker.io/alexfozor/flaresolverr:pr-1300";
        autoStart = true;
        ports = ["127.0.0.1:8191:8191"];
        environment = {
          LOG_LEVEL = "debug";
        };
      };
      tdarr = {
        image = "ghcr.io/haveagitgat/tdarr";
        autoStart = true;
        ports = ["0.0.0.0:8265:8265" "127.0.0.1:8266:8266"];
        volumes = [
          "/var/lib/tdarr/server:/app/server"
          "/var/lib/tdarr/configs:/app/configs"
          "/var/lib/tdarr/logs:/app/logs"
          "/var/lib/media/library:/media"
          "/tmp:/temp"
        ];
        environment = {
          serverIP = "0.0.0.0";
          serverPort = "8266";
          webUIPort = "8265";
          internalNode = "true";
          inContainer = "true";
          ffmpegVersion = "6";
          nodeName = "internal";
          TZ = "Europe/London";
          PUID = "1000";
          PGID = "994";
        };
        extraOptions = ["--device=/dev/dri:/dev/dri" "--network=bridge"];
      };
    };
  };
}
