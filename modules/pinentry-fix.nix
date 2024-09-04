{
  config,
  pkgs,
  lib,
  ...
}: {
  services.dbus.packages = [pkgs.gcr];
}
