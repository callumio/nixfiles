{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    defaultTimeout = 7000;
  };
}
