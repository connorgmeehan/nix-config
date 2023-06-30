{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.colorScheme;
in {
  options.programs.zsh.zinit = {
    enable = mkEnableOption "zinit - Flexible and fast ZSH plugin manager";

    package = mkPackageOption pkgs "zinit" { };

    plugins = mkOption {
      default = [ ];
      type = types.listOf pluginModule;
      description = "List of init plugins.";
    };

    zinitDir = mkOption {
      type = types.str;
      default = "${cfg.package}/share/zinit";
      description = "Path to zinit entry file.";
    };

    config = mkIf cfg.enable {
      home.packages = [ config.package ];

      programs.zsh.initExtraBeforeCompInit = ''
        export ZINIT_HOME=${cfg.zinitDir}
        source "${cfg.zinitDir}/zinit.zsh"

        ${optionalString (cfg.plugins != [ ]) ''
          zinit for \
          ${concatStrings (map (plugin: ''\
            ${
              optionalString (plugin.ice != [ ]) ''\
                ${concatStrings (map (ice: "${ice} \\\n") plugin.ice)}
              ''
            }
            zinit light "${plugin.name}"
          '') cfg.plugins)}
        ''}

      '';

    };
  };
}
