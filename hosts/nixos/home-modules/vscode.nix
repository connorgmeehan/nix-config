{ pkgs, config, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscodium; 
    extensions = [
        pkgs.vscode-extensions.vadimcn.vscode-lldb
    ];
  };
}

