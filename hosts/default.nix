{utils}: let
  hosts = utils.lib.exportModules [
    ./artemis
    ./hermes
  ];
in {inherit hosts;}
