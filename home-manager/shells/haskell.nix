{ pkgs, lib, ... }:
pkgs.devshell.mkShell {
  name = "Haskell development";
  packages = with pkgs; [
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [
      stack
    ]))
  ];
}
