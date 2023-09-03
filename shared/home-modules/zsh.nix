{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.zsh.zinit;

  iceToStr = ices: "zinit ice ${concatStrings (map (ice: " ${ice}") ices)}";
in {
    programs.direnv = {
          enable = true;
          enableZshIntegration = true; # see note on other shells below
          nix-direnv.enable = true;
    };

    programs.zsh = {
        enable = true;
        shellAliases = {
              ns = "nix-shell --command zsh";
              ll = "ls -la";
        };
        initExtraFirst = ''
              source ~/.p10k.zsh
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

        initExtra = ''
              # Netlify Large media
              if [ -f '${config.home.homeDirectory}/.config/netlify/helper/git-config' ]; then source '${config.home.homeDirectory}/.config/netlify/helper/git-config'; fi

              eval "$(fnm env --use-on-cd)"
              export PATH="$PATH":${config.home.homeDirectory}/.cargo/bin

              # PNPM setup
              export PATH="$PATH":${config.home.homeDirectory}/.local/share/pnpm/
              export PNPM_HOME="${config.home.homeDirectory}/.local/share/pnpm/"
        '';

        zinit = {
              enable = true;
              plugins = [
                    { name = "zsh-users/zsh-autosuggestions"; ice = [ "wait'1'" "lucid" ]; } # Simple plugin installation
                    { name = "zsh-users/zsh-syntax-highlighting"; ice = [ "wait'1'" "lucid" ]; } # Simple plugin installation
                    { name = "chisui/zsh-nix-shell"; } # Simple plugin installation
                    { name = "sindresorhus/pure"; ice = [ "compile'(pure|async).zsh'" "pick'async.zsh'" "src'pure.zsh'" ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
                    #{ name = "romkatv/powerlevel10k"; ice = [ "depth=1" ]; strategy = "light"; } # Installations with additional options. For the list of options, please refer to Zplug README.
              ];
        };
    };
}

