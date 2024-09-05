{...}: {
  networking = {
    hostName = "artemis";
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowPing = true;
    enableIPv6 = false;
    nameservers = ["9.9.9.9" "149.112.112.112"];
  };
}
