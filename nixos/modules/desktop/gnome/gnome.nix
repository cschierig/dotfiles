{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.gnome;
in
{
  options.modules.desktop.gnome = {
    enable = mkEnableOption "gnome";
  };
  config = mkIf cfg.enable {
    modules.desktop.enable = true;

    services.xserver = {
      displayManager.gdm.enable = true;
      displayManager.defaultSession = "gnome";
      desktopManager.gnome.enable = true;
    };
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-themes-extra

      gnomeExtensions.blur-my-shell
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.notification-banner-reloaded
      gnomeExtensions.pip-on-top
      gnomeExtensions.spotify-tray
    ];

    environment.gnome.excludePackages = with pkgs.gnome; [
      gnome-software
      epiphany
    ];
  };
}
