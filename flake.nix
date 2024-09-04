{
  description = "C's Nix-Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixinate = {
      url = "github:callumio/nixinate";
      inputs.nixpkgs.follows = "unstable";
    };

    devour-flake = {
      url = "github:srid/devour-flake";
      flake = false;
    };

    nixvim = {
      url = "github:callumio/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";

      # i don't need darwin!!!
      inputs.darwin.follows = "";
    };

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };
    #omnix-flake.url = "github:juspay/omnix?dir=nix/om";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    disko,
    nixpkgs,
    nixinate,
    utils,
    nur,
    home-manager,
    ...
  } @ inputs: let
    inherit (utils.lib) mkApp;
    mods = import ./modules {inherit utils;};
    hosts = import ./hosts {inherit inputs utils;};
    overlay = import ./overlays {inherit inputs;};
  in
    with mods.nixosModules;
      utils.lib.mkFlake {
        inherit self inputs;
        inherit (mods) homeManagerModules nixosModules;
        inherit (hosts) hosts;
        supportedSystems = ["x86_64-linux" "aarch64-linux"];
        channelsConfig.allowUnfree = true;
        channelsConfig.allowBroken = false;

        channels.nixpkgs.overlaysBuilder = channels: [
          (final: prev: {
            inherit (channels) unstable;
          })
        ];

        channels.unstable.overlaysBuilder = channels: [
          (final: prev: {
            jellyfin-ffmpeg = prev.jellyfin-ffmpeg.override {
              ffmpeg_6-full = prev.ffmpeg_6-full.override {
                withMfx = false;
                withVpl = true;
              };
            };
          })
        ];

        sharedOverlays = [
          overlay
          nur.overlay
        ];

        hostDefaults.modules = [home-manager.nixosModules.home-manager inputs.stylix.nixosModules.stylix inputs.agenix.nixosModules.default] ++ mods.sharedModules;

        hostDefaults.extraArgs = {
          inherit inputs;
        };

        outputsBuilder = channels:
          with channels.nixpkgs; {
            defaultPackage = nixvim;
            packages = utils.lib.exportPackages self.overlays channels;

            formatter = alejandra;
            devShell = mkShell {
              packages = [just git nixvim cachix jq devour-flake agenix];
            };
          };
        overlays = utils.lib.exportOverlays {
          inherit (self) pkgs inputs;
        };
        apps.x86_64-linux = (nixinate.nixinate.x86_64-linux self).nixinate;
      };
}
