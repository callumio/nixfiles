{pkgs, ...}: {
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings = {enabled = false;};
      radarr.settings = {
        enabled = true;
        filter = "arr";
        action = ''
          iptables-allports
        '';
        logpath = "/var/lib/radarr/.config/Radarr/logs/radarr.txt";
        backend = "auto";
        maxretry = 4;
        bantime = "52w";
        findtime = "52w";
        chain = "FORWARD";
      };
      sonarr.settings = {
        enabled = true;
        filter = "arr";
        action = ''
          iptables-allports
        '';
        logpath = "/var/lib/sonarr/.config/NzbDrone/logs/sonarr.txt";
        backend = "auto";
        maxretry = 4;
        bantime = "52w";
        findtime = "52w";
        chain = "FORWARD";
      };

      prowlarr.settings = {
        enabled = true;
        filter = "arr";
        action = ''
          iptables-allports
        '';
        logpath = "/var/lib/prowlarr/logs/prowlarr.txt";
        backend = "auto";
        maxretry = 4;
        bantime = "52w";
        findtime = "52w";
        chain = "FORWARD";
      };

      jellyseerr.settings = {
        enabled = true;
        filter = "jellyseerr";
        action = ''
          iptables-allports
        '';
        logpath = "/var/lib/jellyseerr/logs/overseer*.log";
        backend = "auto";
        maxretry = 4;
        bantime = "52w";
        findtime = "52w";
        chain = "FORWARD";
      };

      jellyfin.settings = {
        enabled = true;
        filter = "jellyfin";
        action = ''
          iptables-allports
        '';
        logpath = "/var/lib/jellyfin/log/log*.log";
        backend = "auto";
        maxretry = 4;
        bantime = "52w";
        findtime = "52w";
        chain = "FORWARD";
      };
    };
  };
  environment.etc = {
    "fail2ban/filter.d/arr.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [INCLUDES]
      before = common.conf

      [Definition]
      datepattern = ^%%Y-%%m-%%d %%H:%%M:%%S\.%%f\|
      failregex = ^\s*Warn\|Auth\|Auth-Failure ip <ADDR> username '<F-USER>[^']+</F-USER>'
      ignoreregex =
    '');

    "fail2ban/filter.d/jellyseerr.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*\[warn\]\[API\]: Failed sign-in attempt using invalid Overseerr password {"ip":"<HOST>","email":
                  ^.*\[warn\]\[Auth\]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<HOST>","email":
      ignoreregex =
    '');

    "fail2ban/filter.d/jellyfin.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.
      ignoreregex =
    '');
  };
}
