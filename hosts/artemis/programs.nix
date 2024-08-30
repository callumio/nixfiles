{pkgs, ...}: {
  programs = {
    fish.enable = true;
    seahorse.enable = true;
    nix-ld.enable = true;
    virt-manager.enable = true;
    nm-applet.enable = true;
    hyprland.enable = true;
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
    greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd Hyprland
        '';
      };
    };
  };
}
