{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shells.prompts.starship;
in {
  options.modules.shells.prompts.starship = {
    enable = mkEnableOption' "starship";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ starship ];
    programs.bash.promptInit = ''
      eval "$(starship init bash)"
    '';
  };
}
