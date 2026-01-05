# credits to hlissner/dotfiles
{ inputs, lib, pkgs, ... }:

let
  inherit (builtins) filter;
  inherit (lib) makeExtensible foldr;
  inherit (modules) mapToList;

  modules = import ./modules.nix {
    inherit lib;
  };

  mylib = makeExtensible (self: { });
in
  mylib.extend
    (self: super:
      foldr
        (a: b: a // b)
        {}
        (filter (a: a != null) 
            (mapToList ./.
              (file: import file { inherit self lib pkgs inputs; }))))
