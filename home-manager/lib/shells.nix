{ lib, pkgs, ... }:
let 

in {
  mkShell' = attrs:
    pkgs.devshell.mkShell ({
      shellHook = ''
        nu
        exit
      '';
    } // attrs );
}
