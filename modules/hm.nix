{ ... }:
{
  flake.nixosModules.hm =
    { ... }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    };
}
