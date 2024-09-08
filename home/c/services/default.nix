{...}: {
  imports = [./mako];
  services = {
    network-manager-applet.enable = true;
    mpris-proxy.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
