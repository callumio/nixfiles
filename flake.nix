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

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    #systems.url = "github:nix-systems/default-linux";
    #systems.url = "github:nix-systems/x86_64-linux";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    disko,
    nixpkgs,
    flake-parts,
    nixinate,
    utils,
    home-manager,
    ...
  } @ inputs: let
    mods = import ./modules {inherit utils;};
    mkLinuxSystem = mod:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          [
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.agenix.nixosModules.default
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [self.overlays.default];
            }
            mod
          ]
          ++ mods.sharedModules;
      };
  in
    flake-parts.lib.mkFlake {inherit self inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = import inputs.systems;

      flake = {
        inherit (mods) homeManagerModules nixosModules;
        nixosConfigurations = {
          artemis = mkLinuxSystem ./hosts/artemis;
          hermes = mkLinuxSystem ./hosts/hermes;
        };
        #nixosConfigurations.artemis = inputs.nixpkgs.lib.nixosSystem {};
      };

      perSystem = {
        config,
        pkgs,
        final,
        system,
        inputs',
        self',
        ...
      }: {
        _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend self.overlays.default;
        overlayAttrs = config.packages // {unstable = inputs.unstable.legacyPackages.${system};};

        pre-commit.check.enable = false;
        pre-commit.settings.hooks.alejandra.enable = true;

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.alejandra.enable = true;
        };

        devShells.default = final.mkShell {
          meta.description = "Default dev shell";
          inputsFrom = [config.pre-commit.devShell config.treefmt.build.devShell];
          packages = with final; [just git nixvim cachix jq devour-flake agenix deadnix];
        };

        apps = nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("deploy-" + name) value) (nixinate.nixinate.${system} self).nixinate;

        packages = {
          nixvim = inputs.nixvim.packages.${system}.default;
          agenix = inputs.agenix.packages.${system}.default;
          vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
          devour-flake = pkgs.callPackage inputs.devour-flake {};
          jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {
            ffmpeg_6-full = pkgs.ffmpeg_6-full.override {
              withMfx = false;
              withVpl = true;
            };
          };
        };
      };
    };
}
