# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

# To enable in a host config, import it i.e.
# imports = [ outputs.homeManagerModules.zinit ];

{
  # List your module files here
  # my-module = import ./my-module.nix;
  zinit = import ./zinit.nix;
}
