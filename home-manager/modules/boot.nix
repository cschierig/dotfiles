{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.boot;
in {
  options.modules.boot = {
    splash.enable = mkEnableOption' "splash screen";
  };

  config = mkIf cfg.splash.enable {
    boot = {
      plymouth = {
        enable = true;
      };
      kernelParams = [
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "rd.udev.log_priority=3"
      ];
      initrd.verbose = false;
      consoleLogLevel = 0;
    };
  };
}
