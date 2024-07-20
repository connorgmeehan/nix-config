{ 
    pkgs,
    lib,
    ...
}:

let
  tmux-which-key =
  pkgs.tmuxPlugins.mkTmuxPlugin
  {
    pluginName = "tmux-which-key";
    version = "2024-01-10";
    src = pkgs.fetchFromGitHub {
      owner = "alexwforsythe";
      repo = "tmux-which-key";
      rev = "b4cd9d28da4d0a418d2af5f426a0d4b4e544ae10";
      sha256 = "sha256-ADUgh0sSs1N2AsLC7+LzZ8UPGnmMqvythy97lK4fYgw=";
    };
    rtpFilePath = "plugin.sh.tmux";
  };
in 
{
    home.packages = with pkgs; [tmux-sessionizer];
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.tmux-fzf
        {
            plugin = tmuxPlugins.dracula;
            extraConfig = ''
            # set -g dracula-show-powerline true
            set -g status-position top
            '';
        }
        tmux-which-key
      ];
      extraConfig = '' 
        # used for less common options, intelligently combines if defined in multiple places.
        set -g mouse on # Allow mouse to scroll
        # Emacs key bindings in tmux command prompt (prefix + :) are better than
        # vi keys, even for vim users
        set -g status-keys emacs
        set -sg escape-time 20

        # Focus events enabled for terminals that support them
        set -g focus-events on

        # Super useful when using "grouped sessions" and multi-monitor setup
        setw -g aggressive-resize on

        # Rebinds prefix to `C-s`
        unbind C-b
        set-option -g prefix C-s
        bind-key C-s send-prefix

        # Source config on `C-s r`
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        # Vim like key navigation
        setw -g mode-keys vi
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        bind-key - split-window -v
        bind-key \\ split-window -h

        # forget the find window.  That is for chumps
        bind-key -r s run-shell "tmux neww tms"

        ###
        ### Start Which key
        ###

        set -g @wk_cfg_key_prefix_table "C-s"
        set -g @wk_menu_root '\
        "Suspend session" "C-z" "suspend" \
        "" \
        "[win] Create" "c" new-window \
        "[win] Next" "n" next-window \
        "[win] Prev" "p" previous-window \
        "[win] Prev" "p" previous-window \
        "[win] Kill" "q" kill-window \
        "[win] List" "w" list-window \
        "[win] Vert Split" "\\" "split-window -h" \
        "[win] Hori Split" "-" "split-window -v" \
        "" \
        "[pane] Kill" "-" kill-pane \
        "[pane] Zoom" "z" 
        '

        set -gF @wk_cmd_show \
        "display-menu \
        -x '#{@wk_cfg_pos_x}' \
        -y '#{@wk_cfg_pos_y}' \
        -T '#[#{@wk_cfg_title_style}]#[#{@wk_cfg_title_prefix_style}]#{@wk_cfg_title_prefix}#[#{@wk_cfg_title_style}]'"

        set -gF command-alias[200] show-wk-menu=\
        '#{@wk_cmd_show}'

        set -gF command-alias[201] show-wk-menu-root=\
        '#{@wk_cmd_show} #{@wk_menu_root}'

        set -gF command-alias[202] reload-config=\
        'display "#{log_info} Loading config... " ; \
        source-file $HOME/.tmux.conf'

        set -gF command-alias[203] restart-pane=\
        'display "#{log_info} Restarting pane" ; \
        respawnp -k -c #{pane_current_path}'

        run-shell "tmux bind-key -Tprefix #{@wk_cfg_key_prefix_table} show-wk-menu-root"

      '';
    };
}
