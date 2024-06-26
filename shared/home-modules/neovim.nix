{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.ripgrep
    pkgs.fzf
    pkgs.unzip
    pkgs.ccls
    pkgs.deno
    pkgs.rustywind
    pkgs.lua-language-server
    pkgs.pkg-config
    pkgs.cairo
    pkgs.lldb_14
  ];
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
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

