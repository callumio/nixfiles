{
  inputs,
  utils,
}: let
  # TODO: function to do this
  artemis = import ./artemis {inherit inputs;};
  hermes = import ./hermes {inherit inputs;};
in {
  hosts = {
    inherit artemis;
    inherit hermes;
  };
}
