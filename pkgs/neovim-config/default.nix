{ lib, stdenv, pkgs }:

let
  custom = ./custom;
in
stdenv.mkDerivation {
  pname = "nvchad";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "286c951d7b1f4531c8f40873a3846f40a3503e33";
    sha256 = "sha256-Kiv+Uz+YwzPKLbau93b+QG31Uu+1lQ8KqAS1aYTfil0=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
    mkdir -p "$out/lua/custom"
    cp -r ${custom}/* "$out/lua/custom/"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
