{ pkgs, config, ... }: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /run/media/connorgm/Elements\ SE/shared		192.168.0.0/24(insecure,rw,fsid=0,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };
}
