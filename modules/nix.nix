{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = "gc-keep-outputs = true";
    settings = {
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids"];
      auto-optimise-store = true;
      auto-allocate-uids = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://callumio-public.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "callumio-public.cachix.org-1:VucOSl7vh44GdqcILwMIeHlI0ufuAnHAl8cO1U/7yhg="
      ];
    };
  };
}
