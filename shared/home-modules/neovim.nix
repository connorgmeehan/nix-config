{ config, pkgs, lib, ... }:

{
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

