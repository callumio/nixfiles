{
  config,
  options,
  lib,
  ...
}:
with lib; let
  cfg = config.c.services.mesh;
in {
  options.c.services.mesh = {
    enable = mkEnableOption "Enable tailscale daemon.";
    exitNode = mkOption {
      type = types.bool;
      default = false;
      description = "Enable advertising as an exit node.";
    };
    keyFile = mkOption {
      type = types.path;
      description = "Path to key file.";
    };
  };
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      #authKeyFile = config.age.secrets.mesh-conf.path;
      authKeyFile = cfg.keyFile;
      extraUpFlags = ["--login-server" "https://mesh.cleslie.uk"];
      extraSetFlags = [(mkIf cfg.exitNode "--advertise-exit-node")];
    };
    networking.firewall = {
      #checkReversePath = "loose";
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };
  };
}
