{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shells.nushell;
in {
  options.modules.shells.nushell = {
    enable = mkEnableOption' "nushell";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nushell
      carapace
    ];
  
    environment.shells = [ pkgs.nushell ];
  };
}
