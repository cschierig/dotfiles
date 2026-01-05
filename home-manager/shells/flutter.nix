{ pkgs, lib, ... }:
pkgs.devshell.mkShell {
  name = "C/C++ development";
  packages = with pkgs; [
    flutter
  ];
}
