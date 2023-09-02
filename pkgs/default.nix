# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  neovim-config = pkgs.callPackage ./neovim-config { };
  ny = pkgs.callPackage ./ny.nix { };
  rustywind = pkgs.callPackage ./rustywind.nix { };
  # basis-universal = pkgs.callPackage ./basis-universal.nix { };
  # example = pkgs.callPackage ./example { };
}
