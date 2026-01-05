{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.nixos;
in
{
  options.modules.nixos = {
    enable = mkEnableOption "running on nixos";
  };
}
