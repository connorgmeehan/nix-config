# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  neovim-config = pkgs.callPackage ./neovim-config { };
  ny = pkgs.callPackage ./ny.nix { };
  escape-fsh = pkgs.callPackage ./escape-fhs.nix { };
  zinit = pkgs.callPackage ./zinit.nix { };
  ultrastar-play = pkgs.callPackage ./ultrastar-play.nix { };
  usdb-syncer-0-18 = pkgs.callPackage ./usdb-syncer-0-18.nix { };
  # basis-universal = pkgs.callPackage ./basis-universal.nix { };
  # example = pkgs.callPackage ./example { };
}
