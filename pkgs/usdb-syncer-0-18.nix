{ lib
, stdenv
, fetchurl
, buildFHSEnv
, pkgs
}:

let
  version = "0.18.0";

  binary = stdenv.mkDerivation {
    pname = "usdb-syncer-bin";
    inherit version;

    src = fetchurl {
      url = "https://github.com/bohning/usdb_syncer/releases/download/v${version}/USDB_Syncer-v${version}-Linux";
      sha256 = "sha256-nKPklvII3GPxSHdU71XHTxOa0S2I7zwPL3V5REsjsyg=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out
      cp $src $out/USDB_Syncer
      chmod +x $out/USDB_Syncer
    '';
  };
in

buildFHSEnv {
  pname = "usdb-syncer";
  inherit version;

  # FHS entrypoint
  runScript = "${pkgs.writeShellScript "usdb-syncer-run" ''
    export PATH=${lib.makeBinPath [ pkgs.ffmpeg pkgs.yt-dlp ]}:$PATH
    exec ${binary}/USDB_Syncer "$@"
  ''}";

  targetPkgs = pkgs: with pkgs; [
    portaudio
    alsa-lib
    pulseaudio
    libGL
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXxf86vm
    xorg.libxcb
    xorg.xcbutil
    zlib
    openssl
  ];

  meta = with lib; {
    description = "USDB Syncer – UltraStar song database synchronisation tool";
    homepage = "https://github.com/bohning/usdb_syncer";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
