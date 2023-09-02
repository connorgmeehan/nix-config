{ lib, fetchurl }:

with lib;

let
  sha256sum = "f52edca4859bbbb3bfa2be3d1eb75802b80c7bf305a9c7e97f98cf33613e0aa8";
  url = "https://github.com/krzkaczor/ny/releases/download/v0.1.1/ny-x86_64-unknown-linux-musl.tar.gz";
in
stdenv.mkDerivation rec {
  pname = "ny";
  version = "0.1.1";  # Set the version number accordingly

  src = fetchurl {
    url = url;
    sha256 = sha256sum;
  };

  # Extract the contents of the archive
  unpackPhase = "tar xzf $src";

  # Define a wrapper script or add necessary setup here

  # You can add more build inputs and setup phases as needed
  nativeBuildInputs = [ ];

  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "A description of the ny package";
    license = licenses.mit;
  };
}

