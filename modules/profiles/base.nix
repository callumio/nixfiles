{ config, ... }:
{
  flake.nixosModules.profile-base = {
    import = with config.flake.nixosModules; [
      nix-config
      boot
      keys
      hm # maybe drop and make desktop only?
      secrets
      tailscale
    ];
  };
}
