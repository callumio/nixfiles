{pkgs, ...}: {
  programs = {
    fish.enable = true;
    seahorse.enable = true;
    nix-ld.enable = true;
    virt-manager.enable = true;
    #nm-applet.enable = true;
    hyprland.enable = true;

    regreet = {
      enable = true;
      settings = {
        background = {
          path = pkgs.fetchurl {
            url = "https://i.redd.it/jd1nuwsl0d121.jpg";
            sha256 = "sha256-ff3ajGVsay2dtHiHmO2MYlqCvexUQjGifMs/ofzuyvI=";
          };
          fit = "Contain";
        };
        GTK = {
          application_prefer_dark_theme = true;
          cursor_theme_name = "Adwaita";
          font_name = "Cantarell 16";
          icon_theme_name = "Adwaita";
          theme_name = "Adwaita";
        };
      };
      cageArgs = ["-s" "-m" "last"];
    };
  };
  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    dbus.enable = true;
    printing.enable = true;

    udisks2.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
      #jack.enable = true;
    };

    thermald.enable = true;

    greetd.enable = true;
  };
}
