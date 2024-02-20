{ pkgs, config, ... }:

{
    home.packages = with pkgs; [tmux-sessionizer];
    programs.tmux = {
      enable = true;
      clock24 = true;
      extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
        set -ga terminal-overrides ",screen-256color*:Tc"
        set-option -g default-terminal "screen-256color"
        set -s escape-time 0

        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix
        set -g status-style 'bg=#333333 fg=#5eacd3'

        bind r source-file ~/.tmux.conf
        set -g base-index 1

        set-window-option -g mode-keys vi
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

        # vim-like pane switching
        bind -r ^ last-window
        bind -r k select-pane -U
        bind -r j select-pane -D
        bind -r h select-pane -L
        bind -r l select-pane -R

        # forget the find window.  That is for chumps
        bind-key -r f run-shell "tmux neww tms"

        bind-key -r i run-shell "tmux neww tmux-cht.sh"
      '';
    };
}
