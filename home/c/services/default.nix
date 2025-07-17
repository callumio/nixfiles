{pkgs, ...}: {
  imports = [./mako ./kanshi];
  services = {
    network-manager-applet.enable = true;
    mpris-proxy.enable = true;
    wpaperd.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
