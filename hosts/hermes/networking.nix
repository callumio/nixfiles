{config, ...}: {
  networking = {
    hostName = "hermes";
    enableIPv6 = false;
    firewall.allowedTCPPorts = [80 443 8265];
    firewall.checkReversePath = false;
    iproute2.enable = true;
    iproute2.rttablesExtraConfig = ''
      200 vpn
    '';
    wg-quick.interfaces.wg1 = {
      configFile = config.age.secrets.wg-conf.path;
      table = "vpn";
    };
  };
}
