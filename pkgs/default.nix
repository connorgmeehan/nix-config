# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  neovim-config = pkgs.callPackage ./neovim-config { };
  # example = pkgs.callPackage ./example { };
}
