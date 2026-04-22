{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.lib.mkHost =
    {
      system ? "x86_64-linux",
      modules,
      overlays ? [ ],
    }:
    withSystem system (
      { ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # TODO: REMOVE
        modules = modules ++ [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ config.flake.overlays.default ] ++ overlays;
          }
        ];
      }
    );
}
