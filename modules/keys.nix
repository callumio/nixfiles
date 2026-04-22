{ ... }:
{
  flake.nixosModules.keys =
    { lib, ... }:
    {
      options.keys = lib.mkOption {
        default = import ../lib/keys.nix;
      };
    };
}
