{ lib, stdenv, pkgs }:

let
  custom = ./custom;
  initLuaSrc = ./init.lua;
in
stdenv.mkDerivation {
  pname = "nvchad";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "8d2bb359e47d816e67ff86b5ce2d8f5abfe2b631";
    sha256 = "sha256-1ioUc6WW7eZcgNt4F6mLpIZsj22Gzu7AcqkJoPQ+OVA=";
  };

  installPhase = ''
    mkdir $out
    cp ${initLuaSrc} "$out/init.lua"
    cp -r * "$out/"
    mkdir -p "$out/lua/custom"
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
