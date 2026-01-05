{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.editors.neovim;
in
{
  options.modules.editors.neovim = {
    enable = mkEnableOption' "neovim";
    defaultEditor = mkBooleanOption "make neovim the default editor" true;
    languages = {
      python = mkEnableOption' "python";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim-unwrapped

      # curl
      # git
      # bash

      # copy & paste
      wl-clipboard

      # language toolkits
      # go
      # cargo
      # # C/C++
      # gcc
      # clang
      # clang-tools
      # jdk
      # ruby
      # perl
      # nodejs
      # php
      # luarocks

      ripgrep
      fzf

      # treesitter
      tree-sitter

      # Mason
      # unzip
      # wget
      # curl
      # gzip
      # bash

    ];

    home.sessionVariables.EDITOR = mkIf cfg.defaultEditor "nvim";
  };
}
