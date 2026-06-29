{
  description = "C's Nix-Config";

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
        (inputs.import-tree ./modules)
      ];

      systems = import inputs.systems;

      perSystem =
        {
          config,
          pkgs,
          final,
          inputs',
          ...
        }:
        {
          _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend self.overlays.default;
          overlayAttrs = config.packages // {
            unstable = inputs'.unstable.legacyPackages;
            scenics = inputs'.scenics.packages;
          };

          pre-commit = {
            check.enable = false;
            settings.hooks.nixfmt.enable = true;
            settings.hooks.deadnix.enable = true;
          };

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.deadnix.enable = true;
          };

          devShells.default = final.mkShell {
            meta.description = "Default dev shell";
            inputsFrom = [
              config.pre-commit.devShell
              config.treefmt.build.devShell
            ];
            packages = with final; [
              just
              git
              nvf
              cachix
              jq
              nvd
              devour-flake
              agenix
              deadnix
            ];
          };

          apps = nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair ("deploy-" + name) value) (
            inputs'.nixinate.packages self
          );

          packages = import ./packages { inherit pkgs inputs inputs'; };
        };

      debug = false;
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    scenics.url = "github:callumio/scenics";
    scenics.inputs.nixpkgs.follows = "unstable";

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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
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

    systems.url = "github:nix-systems/triplet";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

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

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "unstable";
    };

    nocodb = {
      url = "github:nocodb/nocodb?ref=bec1fa4";
      #inputs.nixpkgs.follows = "unstable";
    };

    import-tree.url = "github:vic/import-tree";

    nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "unstable";
    };
  };
}
