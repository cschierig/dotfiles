{ config, lib, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.nix;
in {
  options.modules.nix = {
    enableGC = mkBooleanOption "enable running the the gc weekly" true;
    systemFlake = {
      register = mkBooleanOption "whether to register the system flake located at config.modules.nix.systemFlake.path to the global flake registry" true;
      path = mkOption {
        default = ../.;
        example = ./.;
        description = "the path to the directory in which the system flake is saved";
        type = types.path;
      };
    };
  };

  config = {
    nix = {
      registry = mkIf cfg.systemFlake.register {
        system = {
          from = {
            type = "indirect";
            id = "system";
          };
          to = {
            type = "path";
            path = "${cfg.systemFlake.path}";
          };
        };
      };
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Enable automatic GC
      gc = {
        automatic = cfg.enableGC;
        dates = "weekly";
      };
      settings.auto-optimise-store = true;
    };
  };
}
