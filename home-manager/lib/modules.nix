# credits to hlissner/dotfiles
{ lib, ... }:

let
  inherit (builtins) readDir pathExists concatLists listToAttrs;
  inherit (lib) id nameValuePair mapAttrs' hasSuffix removeSuffix mapAttrsToList filterAttrs optionals optionalAttrs zipAttrs;
in rec {  
  # mapToAttrSet :: Path -> (Path -> Any) -> AttrSet
  mapToAttrSet = (dir: fn: 
    mapAttrs'
      (name: value:
        let path = "${toString dir}/${name}"; in
        if value == "directory" then
          nameValuePair name (mapToAttrSet path fn)
        else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name then
          nameValuePair (removeSuffix ".nix" name) (fn path)
        else 
          nameValuePair "" null)
      (readDir dir));

  # mapToFlatSet :: Path -> (Path -> Any) -> AttrSet
  mapToFlatSet = dir: fn: 
    listToAttrs (mapToList dir (p: nameValuePair (removeSuffix ".nix" (baseNameOf p)) (fn p)));

  # mapToList :: Path -> (Path -> Any) -> [Any]
  mapToList = dir: fn:
    concatLists (mapAttrsToList
      (name: value:
        let path = "${toString dir}/${name}"; in
        if value == "directory" then
          (optionals (pathExists "${path}/default.nix") [ (fn path) ]) ++ (mapToList path fn)
        else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name then
          [ (fn path) ]
        else
          [])
      (readDir dir));
}
