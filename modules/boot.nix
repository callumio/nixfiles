{...}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    plymouth.enable = false;
    # consoleLogLevel = 0;
    # initrd.verbose = false;
    # kernelParams = [
    #   "quiet"
    #   "splash"
    #   "boot.shell_on_fail"
    #   "loglevel=3"
    #   "rd.systemd.show_status=false"
    #   "rd.udev.log_level=3"
    #   "udev.log_priority=3"
    # ];
  };
  system.stateVersion = "24.05";
}
