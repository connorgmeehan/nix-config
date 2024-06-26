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
    (import ../../shared/home-modules/kitty.nix (
      args
      # { keybindPrefix = "ctrl+super+"; };
    ))

    ../../shared/home-modules/zsh.nix
    ../../shared/home-modules/neovim.nix
    ../../shared/home-modules/git.nix
    ../../shared/home-modules/lazygit.nix
    ../../shared/home-modules/tmux.nix
    ./home-modules/gnome.nix
    ./home-modules/chromium.nix
    ./home-modules/vscode.nix
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
    };
  };

  # TODO: Set your username
  home = {
    username = "cgm";
    homeDirectory = "/home/cgm";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    zsh
    slack
    spotify
    lazygit
    gittyup

    blender 
    unigine-heaven
    ny

    zoom-us

    unstable.bruno

    nodejs_18
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.serve
    nodePackages.serverless
    nodePackages.npm-check-updates

    unstable.google-chrome
    android-tools

    fzf

    godot_4
  ];
}
