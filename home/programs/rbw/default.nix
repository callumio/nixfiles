{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vaultwarden.cleslie.uk";
      email = "cal@callumleslie.me";
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}
