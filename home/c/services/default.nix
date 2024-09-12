{pkgs, ...}: {
  imports = [./mako ./kanshi];
  services = {
    network-manager-applet.enable = true;
    mpris-proxy.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
