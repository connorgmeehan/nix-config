{ pkgs, config, ... }:

let
  scheme = config.scheme.withHashtag;
in 
{
    home.packages = with pkgs; [tmux-sessionizer];
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        {
            plugin = tmuxPlugins.dracula;
            extraConfig = ''
            set -g dracula-show-powerline true
            set -g status-position top
            '';
        }
      ];
      extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
        set -g mode-mouse on # Allow mouse to scroll

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        unbind C-b
        set-option -g prefix C-s
        bind-key C-s send-prefix

        # Vim like key navigation
        setw -g mode-keys vi
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # forget the find window.  That is for chumps
        bind-key -r f run-shell "tmux neww tms"
        bind-key -r i run-shell "tmux neww curl tmux-cht.sh"
      '';
    };
}
