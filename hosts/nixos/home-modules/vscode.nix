{ pkgs, config, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscodium; 
  };
}

