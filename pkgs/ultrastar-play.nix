{ lib
, stdenv
, fetchzip
, buildFHSEnv
, pkgs
}:

let
  version = "0.9.0";

  data = stdenv.mkDerivation {
    pname = "ultrastar-play-data";
    inherit version;

    src = fetchzip {
      url = "https://github.com/UltraStar-Deluxe/Play/releases/download/v0.9.0/UltraStarPlay-v0.9.0-Linux64.zip";
      sha256 = "sha256-Slkd8SdpQSDQHgDTAehHWBFq8U4QId1l9nSwvxaTalU=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
      chmod +x "$out/UltraStar Play"
    '';
  };
in

buildFHSEnv {
  pname = "ultrastar-play";
  inherit version;

  # THIS is what gets executed
  runScript = "${data}/UltraStar\\ Play";

  targetPkgs = pkgs: with pkgs; [
    mesa
    wayland
    libdecor
    gtk3

    alsa-lib
    pulseaudio

    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXxf86vm
    xorg.libXrender
    ffmpeg

    libGL
    libdrm
    libudev0-shim
    zlib
    openssl
  ];

  meta = with lib; {
    description = "UltraStar Play (Unity)";
    homepage = "https://github.com/UltraStar-Deluxe/Play";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
