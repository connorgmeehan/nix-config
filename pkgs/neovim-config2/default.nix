{ lib, stdenv, pkgs }:

let
  lua = ./lua;
  initLuaSrc = ./init.lua;
in
stdenv.mkDerivation {
  pname = "my-nvim-config";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
    mkdir -p "$out/lua"
    cp -r ${lua}/* "$out/lua"
  '';

  meta = with lib; {
    description = "neovim config";
    platforms = platforms.all;
  };
}

