{
  description = "C's Nix-Config";

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs: let
    mods = import ./modules;
    cLib = import ./lib {inherit (nixpkgs) lib;};
    mkLinuxSystem = mod: ovl:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs cLib;};
        modules =
          [
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.agenix.nixosModules.default
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [self.overlays.default] ++ ovl;
            }
          ]
          ++ mod
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
        # TODO: use ./hosts/
        nixosConfigurations = {
          artemis = mkLinuxSystem [./hosts/artemis inputs.lanzaboote.nixosModules.lanzaboote] [];
          hermes = mkLinuxSystem [./hosts/hermes inputs.copyparty.nixosModules.default] [inputs.copyparty.overlays.default];
        };
        diskoConfigurations = {}; # maybe?
        om.health.default = {nix-version.min-required = "2.18.5";};
      };

      perSystem = {
        config,
        pkgs,
        final,
        inputs',
        ...
      }: {
        _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend self.overlays.default;
        overlayAttrs = config.packages // {unstable = inputs'.unstable.legacyPackages;};

        pre-commit = {
          check.enable = false;
          settings.hooks.alejandra.enable = true;
          settings.hooks.deadnix.enable = true;
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.alejandra.enable = true;
          programs.deadnix.enable = true;
        };

        devShells.default = final.mkShell {
          meta.description = "Default dev shell";
          inputsFrom = [config.pre-commit.devShell config.treefmt.build.devShell];
          packages = with final; [just git nvf cachix jq devour-flake om agenix deadnix];
        };

        apps = nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("deploy-" + name) value) (inputs'.nixinate.packages self);

        packages = import ./packages {inherit pkgs inputs inputs';};
      };

      debug = false;
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixinate = {
      url = "github:callumio/nixinate";
      inputs.nixpkgs.follows = "unstable";
    };

    devour-flake = {
      url = "github:srid/devour-flake";
      flake = false;
    };

    nvf = {
      url = "github:callumio/nvf";
      inputs.nixpkgs.follows = "unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";

      inputs.darwin.follows = "";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omnix = {
      url = "github:juspay/omnix";
      inputs = {
        systems.follows = "systems";
      };
    };

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
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nish = {
      url = "github:callumio/nish";
      inputs = {
        nixpkgs.follows = "unstable";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

    nsbm = {
      url = "github:callumio/nsbm";
      inputs = {
        nixpkgs.follows = "unstable";
        treefmt-nix.follows = "treefmt-nix";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "unstable";
    };
  };
}
