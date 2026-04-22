{...}: {
  flake.nixosModules.gpg-pinentry-wayland = {pkgs, ...}: {
    services.dbus.packages = [pkgs.gcr];
  };
}
