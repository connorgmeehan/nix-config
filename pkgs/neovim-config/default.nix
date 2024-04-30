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
    rev = "f8e6c59985f1d5f820f051395e88064a8d16ef2a";
    sha256 = "sha256-pE3len10QUOXFQzbL8YWfPjmWjJPepBkY29SZO88Rus=";
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
