{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "24.05"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Neovim
    neovim-unwrapped
    luarocks
    ruby
    julia
    go
    php
    (config.lib.nixGL.wrap neovide) 
    (config.lib.nixGL.wrap ghostty) 
    uv
    typst

    hotspot

    tailwindcss_4

    broot
    packwiz
    nushell
    commitizen
    tea
    tokei
    bat
    hyperfine

    zellij
    starship
    carapace
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixGL.packages = inputs.nixGL.packages;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
