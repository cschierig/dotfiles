{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "carl";
  home.homeDirectory = "/home/carl";
}
