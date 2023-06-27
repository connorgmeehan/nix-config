{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cvim = "NVIM_APPNAME=nvchad nvim";
    };
    initExtraFirst = ''
      source ~/.p10k.zsh
    '';
    initExtra = ''
      prompt_nix_shell_setup

      eval "$(fnm env --use-on-cd)"
    '';
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
}

