{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.nodejs_20 # For installing extra language servers with mason
    pkgs.nodePackages.typescript # Global typescript installation for tsserver

    pkgs.luajit
    pkgs.luarocks

    pkgs.eslint_d
    pkgs.nodePackages.prettier
    pkgs.ripgrep
    pkgs.fzf
    pkgs.unzip
    pkgs.ccls
    pkgs.deno
    pkgs.rustywind
    pkgs.lua-language-server
    pkgs.pkg-config
    pkgs.cairo
    pkgs.lldb_19
    pkgs.gh
  ];
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
  };

  # Config and plugins
  xdg.configFile."nvim" = {
    source = "${pkgs.neovim-config}";
  };

  programs.bash.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';
  programs.zsh.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';
}

