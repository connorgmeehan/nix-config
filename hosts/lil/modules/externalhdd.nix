{ config, pkgs, ... }:

let
  # Replace with the actual device name or UUID of your external HDD.
  externalHddDevice = "/dev/disk/by-label/ExternalDrive";
in

{
  # Ensure the externalhdd group exists
  users.groups.externalhdd = {};

  # Mount the external USB HDD after login to /run/media/externalhdd
  systemd.services.mount-externalhdd = {
    description = "Mount External USB HDD";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.coreutils}/bin/mkdir -p /run/media/externalhdd"
        "${pkgs.util-linux}/bin/mount ${externalHddDevice} /run/media/externalhdd"
        "${pkgs.coreutils}/bin/chown :externalhdd /run/media/externalhdd"
      ];
      ExecStop = [
        "${pkgs.util-linux}/bin/unmount /run/media/externalhdd"
      ];
    };

    # Specify that this should run after the user logs in
    wantedBy = [ "default.target" ];
  };
}

