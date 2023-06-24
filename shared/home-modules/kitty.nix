# keybindPrefix {string} Prefix for various keybinds like Super+c to copy
{ config, pkgs, lib, keybindPrefix ? "ctrl+super+",  ... }:

let 
  TEST_1 = lib.debug.traceVal ("Building kitty config with ${keybindPrefix}");
in
{
  programs.kitty = {
    enable = true;
    keybindings = lib.mapAttrs' (keybind: action: lib.nameValuePair (keybindPrefix + keybind) (action)) {
      "c" = "copy_to_clipboard";
      "v" = "paste_from_clipboard";
      "w" = "close_window";
      "t" = "new_tab";
    };
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "Hack" ]; });
      name = "Hack Nerd Font";
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
    };
  };
}
