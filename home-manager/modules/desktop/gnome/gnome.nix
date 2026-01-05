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

    services = {
      displayManager.defaultSession = "gnome";
      xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    };
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-themes-extra

      gnomeExtensions.blur-my-shell
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.notification-banner-reloaded
      gnomeExtensions.pip-on-top
      gnomeExtensions.spotify-tray

      gradience
    ];

    environment.gnome.excludePackages = with pkgs.gnome; [
      gnome-software
    ];
  };
}
