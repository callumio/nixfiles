{inputs, ...}: {
  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
      DisableTelemetry = true;
    };

    profiles.c = {
      bookmarks = [
        {
          name = "NixOS";
          toolbar = true;
          bookmarks = [
            {
              name = "Packages";
              url = "https://search.nixos.org";
            }
            {
              name = "Wiki";
              url = "https://nixos.wiki";
            }
          ];
        }
        {
          name = "News";
          toolbar = true;
          bookmarks = [
            {
              name = "Al Jazeera";
              url = "https://aljazeera.com";
            }
          ];
        }
      ];

      containers = {};

      settings = {};

      userChrome = "";

      userContent = "";

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        darkreader
        youtube-shorts-block
        privacy-badger
        return-youtube-dislikes
      ];
    };
  };
}
