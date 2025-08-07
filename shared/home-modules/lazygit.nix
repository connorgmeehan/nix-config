{ config, pkgs, ... }:

let 
  scheme = config.scheme.withHashtag;
in
{
  programs.lazygit = {
    package = pkgs.unstable.lazygit;
    enable = true;
    settings = {
      os.editPreset = "nvim";

      services = {
        gh-work = "github:github.com";
      };
      gui.theme = {
        activeBorderColor = [ scheme.base04 "bold" ];
        inactiveBorderColor = [ scheme.base08 ];
        optionsTextColor = [ scheme.base07 ];
        defaultFgColor = [ scheme.base0F ];
        selectedLineBgColor = [ scheme.base08 ];
        selectedRangeBgColor = [ scheme.base04 ];
        cherryPickedCommitBgColor = [ scheme.base0D ];
        cherryPickedCommitFgColor = [ scheme.base00 ];
        unstagedChangesColor = [ scheme.base01 ];
      };
      git.paging.externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
    };
  };
}
