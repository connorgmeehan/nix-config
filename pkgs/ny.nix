{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:

# Ny requires rust nightly
rustPlatform.buildRustPackage rec {
  pname = "ny";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "krzkaczor";
    repo = pname;
    rev = version;
    hash = "sha256-LanRXZ031NemARBvQX5GLZgqn7lOY1R+N4wT4uWI0mA=";
  };

  cargoHash = "sha256-WXJU+LC9wbsHVJIL2ZnVzkKJyL5CZXJi9TO9Z42CUr0=";

  env = {
    # requires nightly features
    RUSTC_BOOTSTRAP = true;
  };

  meta = with lib; {
    description = "A description of the ny package";
    homepage = "https://github.com/krzkaczor/ny";
    license = licenses.mit;
  };
}

