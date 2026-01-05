{ config, pkgs, inputs, lib, ... }:
{
  ############
  # Dual Boot
  ############

  # Fix windows clock
  time.hardwareClockInLocalTime = true;

  ###########
  # Packages
  ###########

  modules.desktop.gnome.enable = true;

  # Steam
  programs.steam = {
    enable = true;
  };

  ###########
  # Security
  ###########

  security.tpm2 = {
    enable = true;
  };

  ##########
  # Booting
  ##########

  boot.loader.systemd-boot.consoleMode = "max";

  ##########
  # Drivers
  ##########

  # Nvidia proprietary
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.opengl.enable = true;
}
