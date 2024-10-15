{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vaultwarden.cleslie.uk";
      email = "vw@cleslie.uk";
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}
