{ config, pkgs, inputs, lib, ... }:
{

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";


  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  ############
  # Dual Boot
  ############

  # Fix windows clock
  time.hardwareClockInLocalTime = true;

  ###########
  # Packages
  ###########

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    # jetbrains.idea-ultimate
    (symlinkJoin {
      name = "idea-ultimate";
      paths = [ jetbrains.idea-ultimate ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/idea-ultimate \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libpulseaudio libGL glfw openal stdenv.cc.cc.lib flite]}"
      '';
    })
    jetbrains.rider

    unityhub

    maven
    gnumake

    krita
    inkscape
    aseprite
    blockbench

    xournalpp
    nextcloud-client
    filezilla

    # wacom
    xf86_input_wacom
    wacomtablet
    libwacom

    # uni
    wireshark
  ];

  # Gnome

  modules.desktop.gnome.enable = true;
  services.libinput.enable = true;

  ###########
  # Security
  ###########

  security.tpm2 = {
    enable = true;
  };

  security.pki.certificateFiles = [ ./kit.pem ];

  ##########
  # Booting
  ##########

  boot.loader.timeout = 0;

  ##########
  # Drivers
  ##########

  # Firmware
  services.fwupd.enable = true;
}
