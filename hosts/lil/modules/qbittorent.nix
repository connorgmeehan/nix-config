{ pkgs, config, ... }: {
  services.qbittorrent = {
    enable = true;
    group = "externalhdd";
    webuiPort = 8095;
    openFirewall = true;
  };
  users.users.qbittorrent.extraGroups = [ "externalhdd" ];
}
