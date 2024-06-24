# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

args@{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    inputs.base16.homeManagerModule
    outputs.homeManagerModules.zinit

    ../../shared/home-modules/colors.nix
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # Imports module with custom arguments
    (import ../../shared/home-modules/kitty.nix ( lib.mergeAttrs args {
      keybindPrefix = "cmd+";
    } ))

    ../../shared/home-modules/tmux.nix
    ../../shared/home-modules/zsh.nix
    ../../shared/home-modules/neovim.nix
    ../../shared/home-modules/git.nix
    ../../shared/home-modules/lazygit.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Overlay useful on Macs with Apple Silicon
      # apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      #   # Add access to x86 packages system is running Apple Silicon
      #   pkgs-x86 = import inputs.nixpkgs-unstable {
      #     system = "x86_64-darwin";
      #     inherit (nixpkgsConfig) config;
      #   };
      # }; 

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);

      allowUnsupportedSystem = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "connormeehan";
    homeDirectory = "/Users/connormeehan";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    nodePackages.yarn
    nodePackages.pnpm

    awscli2
    lazygit
    rustup
    fzf
  ];
}
