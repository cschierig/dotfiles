{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.gnome;
in
{
  options.modules.desktop.gnome = {
    brightness-control.enable = mkEnableOption' "Monitor brightness control";
  };

  config = mkIf (cfg.enable && cfg.brightness-control.enable)
    {
      environment.systemPackages = with pkgs; [
        gnomeExtensions.brightness-control-using-ddcutil
        ddcutil
      ];

      users.groups = {
        i2c = { };
      };

      services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';

      boot = {
        kernelModules = [
          "i2c-dev"
        ];
      };
    };
}
