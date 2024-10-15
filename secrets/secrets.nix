let
  keys = import ../lib/keys.nix;
  systems = {
    hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnmnOWpdewwytd15JcnJvJWbIE8hcMu/pp1TPqsvdol";
    artemis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILERlCL5ZwP/mmtBNAMtLrUwEDy+tOprUWUmsGBRlTCF";
  };
  allSystems = builtins.attrValues systems;
in {
  "wg-conf.age".publicKeys = keys.c ++ allSystems;
  "mesh-conf-infra.age".publicKeys = keys.c ++ allSystems;
  "mesh-conf-cleslie.age".publicKeys = keys.c ++ allSystems;
  "forgejo-password.age".publicKeys = keys.c ++ [systems.hermes];
  "cloudflare-api.age".publicKeys = keys.c ++ [systems.hermes];
  "vaultwarden-env.age".publicKeys = keys.c ++ [systems.hermes];
}
