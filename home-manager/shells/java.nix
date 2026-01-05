{ pkgs, lib, ... }:
pkgs.devshell.mkShell {
  name = "Java development";
  packages = with pkgs; [
    jdk
    checkstyle
  ];
}
