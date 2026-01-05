{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in rec {
  # like lib.mkEnableOption, but defaults to true
  mkEnableOption' = name: (mkEnableOption name) // { default = true; example = false; };
  # create an option which is either true or false
  mkBooleanOption = description: default: mkOption {
    default = default;
    example = !default;
    description = description;
    type = types.bool;
  };
}
