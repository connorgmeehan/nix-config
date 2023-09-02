{ pkgs, config, ... }: {
  programs.adb.enable = true;
  users.users.cgm.extraGroups = ["adbusers"];
}
