{ lib, buildPackages, fetchurl, opencl ? null }:  # Import necessary functions and packages

buildPackages.stdenv.mkDerivation {
  pname = "basis-universal";
  version = "1.16.4";
  
  src = fetchurl {
    url = "https://github.com/BinomialLLC/basis_universal/releases/download/1.16.4/basisu_v1_16_4.7z";
    sha256 = "0akbs142shjxn1sgzwc94q7qvybfgfwx55l0wf59a5fw9y5zpyhl";
  };
  
  nativeBuildInputs = [ buildPackages.cmake ];
  
  meta = with lib; {
    description = "Basis Universal Supercompressed GPU Texture Codec";
    license = licenses.mit;
  };

  # If the package depends on OpenCL, add the appropriate dependency
  preConfigure = ''
    # Optionally, you can do some pre-configuration steps here
  '';

  buildPhase = ''
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$out ${lib.optionalString opencl "-DOPENCL_INCLUDE_DIR=/path/to/opencl/include -DOPENCL_LIBRARY=/path/to/opencl/library"}
    make
  '';

  installPhase = ''
    make install
  '';
}
