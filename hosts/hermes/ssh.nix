{...}: {
  services = {
    openssh = {
      enable = true;
      ports = [62480];
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "no";
    };
    endlessh-go = {
      enable = true;
      port = 22;
      openFirewall = true;
    };
  };
}
