{inputs, ...}: _final: prev: {
  nixvim = inputs.nixvim.packages.${prev.system}.default;
  nvf = inputs.nvf.packages.${prev.system}.default;
  devour-flake = prev.callPackage inputs.devour-flake {};
  agenix = inputs.agenix.packages.${prev.system}.default;
}
