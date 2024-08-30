{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "rtsx_pci_sdmmc"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    #kernelPackages = pkgs.linuxPackages_latest;
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {General = {Enable = "Source,Sink,Media,Socket";};};
    };

    opengl = {
      # hardware.graphics on unstable
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
        vaapiVdpau
        intel-compute-runtime
        unstable.vpl-gpu-rt
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

  services = {
    blueman.enable = true;

    power-profiles-daemon.enable = false;
    system76-scheduler.settings.cfsProfiles.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
  };
  powerManagement.powertop.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5488764f-a50a-4ea2-ac8d-bfe565199018";
    fsType = "ext4";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
}
