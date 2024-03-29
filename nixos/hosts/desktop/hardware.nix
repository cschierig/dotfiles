{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e8dfcb47-066a-4693-8b19-596cbaddf8e3";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/e8dfcb47-066a-4693-8b19-596cbaddf8e3";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/213b4be8-040b-4d78-a430-302d310e78b0";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/F4FE-A785";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/06ece79a-ae1b-4536-83b3-8c11027709b0";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/e8dfcb47-066a-4693-8b19-596cbaddf8e3";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
