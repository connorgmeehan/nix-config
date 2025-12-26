{ pkgs, config, ... }: {
  services.deluge = {
    enable = true;
    web.enable = true;
    web.openFirewall = true;
  };
}
