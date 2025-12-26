{ config, pkgs, ... }:

let
  # Replace with the actual device name or UUID of your external HDD.
  externalHddDevice = "/dev/disk/by-label/ExternalMedia2TB";
in

{
  # Ensure the externalhdd group exists
  users.groups.externalhdd = {};

  # Mount the external USB HDD after login to /run/media/externalhdd
  systemd.services.mount-externalhdd = {
    description = "Mount External USB HDD";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        /run/wrappers/bin/mount ${externalHddDevice} /run/media/externalhdd
        /run/wrappers/bin/chown :externalhdd /run/media/externalhdd
      '';
      RemainAfterExit = true;
    };

    # Specify that this should run after the user logs in
    wantedBy = [ "default.target" ];
  };
}

