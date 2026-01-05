{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = mkEnableOption "desktop";
    flatpak.enable = mkEnableOption' "flatpak";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
    };
    programs.xwayland.enable = true;

    xdg.portal.enable = true;

    services.flatpak.enable = cfg.flatpak.enable;
  };
}
