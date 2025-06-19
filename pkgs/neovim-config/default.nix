{ lib, stdenv, pkgs }:

let
  custom = ./custom;
  initLuaSrc = ./init.lua;
in
stdenv.mkDerivation {
  pname = "nvchad";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
    mkdir -p "$out/lua"
    cp -r ${custom}/* "$out/lua"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
