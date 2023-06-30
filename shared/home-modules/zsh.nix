{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.zsh.zinit;

  iceToStr = ices: "zinit ice ${concatStrings (map (ice: " ${ice}") ices)}";
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      cvim = "NVIM_APPNAME=nvchad nvim";
    };
    initExtraFirst = ''
      source ~/.p10k.zsh
    '';
    initExtra = ''
      eval "$(fnm env --use-on-cd)"
    '';


    enableCompletion = false;
    initExtraBeforeCompInit = ''
      export ZINIT_HOME=${cfg.zinitDir}
      source "${cfg.zinitDir}/zinit.zsh"

      ${optionalString (cfg.plugins != [ ]) ''
        ${concatStrings (map (plugin: '' 
          ${ optionalString (plugin.ice != [ ]) (iceToStr plugin.ice) }
          zinit ${plugin.strategy} ${plugin.name}
        '') cfg.plugins)}
      ''}
    '';
    zinit = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "zsh-users/zsh-syntax-highlighting"; ice = [ "wait'1'" ]; } # Simple plugin installation
        { name = "sindresorhus/pure"; ice = [ "compile'(pure|async).zsh'" "pick'async.zsh'" "src'pure.zsh'" ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        #{ name = "romkatv/powerlevel10k"; ice = [ "depth=1" ]; strategy = "light"; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
}

