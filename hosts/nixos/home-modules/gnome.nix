{ pkgs, ... }:

{
  # ...
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "caffeine@patapon.info"
      ];
    };
  };

  home.packages = with pkgs; [
    # ...
    gnomeExtensions.caffeine
  ];
}

