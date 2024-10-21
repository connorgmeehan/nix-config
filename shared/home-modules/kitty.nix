# keybindPrefix {string} Prefix for various keybinds like Super+c to copy
{ config, pkgs, lib, keybindPrefix ? "ctrl+super+",  ... }:

let 
  scheme = config.scheme.withHashtag;
in
{
  programs.kitty = {
    enable = true;
    keybindings = lib.mapAttrs' (keybind: action: lib.nameValuePair (keybindPrefix + keybind) (action)) {
      "c" = "copy_to_clipboard";
      "v" = "paste_from_clipboard";
      "w" = "close_window";
      "t" = "new_tab";
      "opt+," = "debug_config";
    };
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      name = "JetBrainsMono";
    };
    environment = {
      KITTY_ENABLE_WAYLAND = "1";
    };
    settings = {
      # Font
      font_size = "12.0";

      #Keybinds

      # Scrollback
      scrollback_lines = 10000;

      # Open URLs on click without modifier
      mouse_map = "left click ungrabbed mouse_click_url_or_select";

      # Bell
      visual_bell_duration = "0.0";
      enable_audio_bell = false;
      window_alert_on_bell = true;
      bell_on_tab = true;

      # Misc
      editor =
        if config.programs.neovim.enable then
          "${config.programs.neovim.finalPackage}/bin/nvim"
        else
          "${pkgs.neovim}/bin/nvim";
      strip_trailing_spaces = "smart";
      clipboard_control =
        "write-clipboard write-primary read-clipboard read-primary";

      # Fix for Wayland slow scrolling
      touch_scroll_multiplier = "5.0";

      # For nnn
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";

      # Colorscheme defined in xdg.configFile below
      include = "theme.conf";
    };
  };

  xdg.configFile."kitty/theme.conf".text = ''
    background #212733
    foreground #d9d7ce
    cursor #ffcc66
    selection_background #343f4c
    selection_foreground #212733

    color0 ${scheme.base00}
    color1 ${scheme.base01}
    color2 ${scheme.base02}
    color3 ${scheme.base03}
    color4 ${scheme.base04}
    color5 ${scheme.base05}
    color6 ${scheme.base06}
    color7 ${scheme.base07}
    color8 ${scheme.base08}
    color9 ${scheme.base09}
    color10 ${scheme.base0A}
    color11 ${scheme.base0B}
    color12 ${scheme.base0C}
    color13 ${scheme.base0D}
    color14 ${scheme.base0E}
    color15 ${scheme.base0F}
  '';
}

