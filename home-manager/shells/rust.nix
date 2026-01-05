{ pkgs, lib, ... }:

with lib.my;

let 
  buildInputs = with pkgs; [
    wayland
    wayland-protocols
    openssl.dev
    openssl
  ];
  libPath = lib.makeLibraryPath buildInputs;
in
  pkgs.devshell.mkShell {
    name = "Rust development";
    packages = (with pkgs; [
      (pkgs.fenix.complete.withComponents [
        "cargo"
        "rust-src"
        "rustc"
        "rustfmt"
        "clippy"
      ])
      gcc
      pkg-config
    ]) ++ buildInputs;
    env = [
      {
        name = "PKG_CONFIG_PATH";
        value = "${pkgs.openssl.dev}/lib/pkgconfig:${libPath}";
      }
      {
        name = "LD_LIBRARY_PATH";
        value = "${libPath}";
      }
    ];
  }
