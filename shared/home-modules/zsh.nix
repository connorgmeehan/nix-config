{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.zsh.zinit;

  iceToStr = ices: "zinit ice ${concatStrings (map (ice: " ${ice}") ices)}";
in {
    home.packages = with pkgs; [
      fnm
    ];

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

        initExtra = ''
              # Netlify Large media
              if [ -f '${config.home.homeDirectory}/.config/netlify/helper/git-config' ]; then source '${config.home.homeDirectory}/.config/netlify/helper/git-config'; fi

              export PATH="$PATH":${config.home.homeDirectory}/.cargo/bin

              # PNPM setup
              export PATH="$PATH":${config.home.homeDirectory}/.local/share/pnpm/
              export PNPM_HOME="${config.home.homeDirectory}/.local/share/pnpm/"

              # FNM setup
              eval "$(fnm env --use-on-cd)"
        '';

        zinit = {
            enable = true;
            enableSyntaxCompletionsSuggestions = true;
            plugins = [
                { name = "chisui/zsh-nix-shell"; } # Simple plugin installation
                { name = "sindresorhus/pure"; ice = { 
                  compile = "(pure|async).zsh";
                  pick = "async.zsh";
                  src = "pure.zsh";
                };
              } # Installations with additional options. For the list of options, please refer to Zplug README.
            ];
        };
    };
}

