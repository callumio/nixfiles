{pkgs, ...}: {
  stylix = {
    enable = true;

    image = pkgs.fetchurl {
      url = "https://i.redd.it/jd1nuwsl0d121.jpg";
      sha256 = "sha256-ff3ajGVsay2dtHiHmO2MYlqCvexUQjGifMs/ofzuyvI=";
    };

    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 16;
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    targets = {
      fish.enable = false;
    };
  };
}
