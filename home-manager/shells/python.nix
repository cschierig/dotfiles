{ pkgs, lib, ... }:
pkgs.devshell.mkShell {
  name = "Python development";
  packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ pip ]))
  ];
}
