# hlissner/dotfiles (once again)
{ inputs, lib, pkgs, ... }:
let
  inherit (lib.my) mapToList;
  inherit (lib) mapAttrs' nameValuePair nixosSystem id mkDefault;
  inherit (lib.hm) homeManagerConfiguration;
  inherit (builtins) map listToAttrs readDir;
  sys = "x86_64-linux";
in
{
  # mapHosts :: Path -> AttrSet -> AttrSet
  mapHosts = dir: attrs @ { system ? sys, stateVersion, modules ? [ ] }:
    mapAttrs'
      (name: value:
        let path = "${toString dir}/${name}"; in
        if value == "directory" && name != "_common" then
          nameValuePair name
            (nixosSystem {
              inherit system;
              specialArgs = { inherit pkgs inputs lib; };
              modules =
                [{
                  networking.hostName = mkDefault name;
                  system.stateVersion = stateVersion;
                }] ++
                modules ++
                mapToList path id ++
                mapToList "${toString dir}/_common" id ++
                mapToList ../modules id;
            })
        else
          nameValuePair "" null)
      (readDir dir);

  # mapHome :: Path -> AttrSet -> AttrSet
  mapHome = dir: attrs @ { system ? sys, stateVersion, modules ? [ ] }:
    mapAttrs'
      (name: value:
        let path = "${toString dir}/${name}"; in
        if value == "directory" && name != "_common" then
          nameValuePair name
            (homeManagerConfiguration {
              inherit pkgs lib;
              extraSpecialArgs = { inherit inputs; };
              modules =
                [{ }] ++
                modules ++
                mapToList path id ++
                mapToList "${toString dir}/_common" id;
            })
        else
          nameValuePair "" null)
      (readDir dir);
}
