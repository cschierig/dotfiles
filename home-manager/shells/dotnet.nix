{ pkgs, lib, ... }:
pkgs.devshell.mkShell {
  name = ".NET development";
  packages = with pkgs; [
    dotnet-sdk
    omnisharp-roslyn
  ];
}
