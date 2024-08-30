{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.remote-deploy;
in {
  options.services.remote-deploy = {
    enable = mkEnableOption "Enable remote deployment with nixinate.";
    host = mkOption {
      type = types.str;
      description = "Hostname to connect to.";
    };
    user = mkOption {
      type = types.str;
      default = "deploy";
      description = "Username for deploy account.";
    };
    group = mkOption {
      type = types.str;
      default = "deploy";
      description = "Group for deploy account.";
    };
    keys = mkOption {
      type = types.listOf types.str;
      description = "Authorised SSH keys for deployment";
    };
    port = mkOption {
      type = types.port;
      default = 22;
      description = "SSH port to use.";
    };
    buildOn = mkOption {
      type = types.enum ["local" "remote"];
      default = "local";
      description = "Where to build the config.";
    };

    substituteOnTarget = mkOption {
      type = types.bool;
      default = true;
      description = "Substitute closures and paths from remote";
    };
  };
  config = mkIf cfg.enable {
    _module.args = {
      nixinate = {
        inherit (cfg) host buildOn port substituteOnTarget;
        sshUser = cfg.user;
      };
    };
    users.groups."${cfg.group}" = {};
    users.users."${cfg.user}" = {
      isSystemUser = true;
      shell = pkgs.bash;
      inherit (cfg) group;
      openssh.authorizedKeys.keys = cfg.keys;
    };
    nix.settings.trusted-users = [cfg.user];
    security.sudo.extraRules = [
      {
        groups = [cfg.group];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
