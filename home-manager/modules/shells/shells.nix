{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shells;
in {
  options.modules.shells = {
    loginShell = mkOption {
      default = pkgs.nushell;
    };
  };
}
