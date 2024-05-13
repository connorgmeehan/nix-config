{ pkgs, config, ... }: {
  users.users.shareuser = {

  }
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = NixOS_Samba
      netbios name = NixOS_Samba
      security = user 
      #use sendfile = yes
      #max protocol = smb2
    '';
    shares = {
      public = {
        path = "/mnt/Shares/Public";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "cgm";
        "forceuser" = "shareuser";
      };
      private = {
        path = "/mnt/Shares/Private";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "cgm";
        "forceuser" = "shareuser";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/Shares/Public - -"
    "d /mnt/Shares/Private - -"
  ];

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}
