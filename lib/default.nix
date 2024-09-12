{lib, ...}: let
  getProgFor' = pkgs: prog: progn: lib.getExe' pkgs.${prog} progn;
  getProgFor = pkgs: prog: getProgFor' pkgs prog prog;
in {
  inherit getProgFor getProgFor';
}
