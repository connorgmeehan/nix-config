{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zinit;

  pluginModule = types.submodule ({ config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the plugin.";
      };

      ice = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "The plugin ice config as a list.";
      };

      strategy = mkOption {
        type = types.str;
        default = "light";
        description = "The load strategy (light|load)";
      };
    };

  });
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
  };
}
