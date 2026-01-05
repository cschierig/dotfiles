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
    environment.systemPackages = [

      (
        let
          neovim-fhs = pkgs.buildFHSEnvChroot {
            name = "nvim";
            targetPkgs = (inpkgs: (with inpkgs; [
              neovim-unwrapped

              # copy & paste
              wl-clipboard

              # language toolkits
              go
              cargo
              # C/C++
              gcc
              clang
              clang-tools
              jdk
              ruby
              perl
              nodejs
              php
              luarocks

              # rust
              (fenix.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly

              git
              bash

              # mason
              curl
              wget
              unzip

              # todo-comments
              ripgrep
            ] ++ optionals cfg.languages.python [
              (python3.withPackages (ps: with ps; [
                pip
                pynvim
                virtualenv
              ]))
            ]));
            runScript = "nvim";
          };
        in
        neovim-fhs
      )
    ];

    environment.sessionVariables.EDITOR = mkIf cfg.defaultEditor "nvim";
  };
}
