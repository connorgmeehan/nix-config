{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.unzip
    pkgs.ccls
    pkgs.deno
    pkgs.rustywind
    pkgs.unstable.rust-analyzer
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Config and plugins
  xdg.configFile."nvim" = {
    source = "${pkgs.neovim-config}";
    recursive = false;
  };

  programs.bash.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';
  programs.zsh.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';
}

