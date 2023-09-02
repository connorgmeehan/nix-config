{ stdenv, lib, fetchurl, makeWrapper, libGL, libX11, zlib, openal, libXcursor, libXi, python3, freetype, openimageio, libsamplerate, tbb, python310Packages }:

let
  pname = "blender";
  version = "3.6.0";
  # python = python310Packages.python;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    libGL
    libX11
    zlib
    openal
    libXcursor
    libXi
    python3
    freetype
    openimageio
    libsamplerate
    tbb
  ];
in
stdenv.mkDerivation {
  pname = pname;
  src = fetchurl {
    url = "https://download.blender.org/release/Blender3.6/blender-${version}-linux64.tar.xz";
    sha256 = "1c277b781726c17b4145cf2313497716fecd8e2941a757625afe4c4a76a743ed";
  };

  nativeBuildInputs = nativeBuildInputs;
  buildInputs = buildInputs;

  unpackPhase = ''
    tar -xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -R * $out/
    wrapProgram $out/blender \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath buildInputs}
  '';

  meta = with lib; {
    description = "A free and open source 3D creation suite";
    homepage = "https://www.blender.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
