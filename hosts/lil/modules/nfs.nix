{ pkgs, config, ... }: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /export		192.168.0.0/24(insecure,rw,fsid=0,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /export/shared	192.168.0.0/24(insecure,rw,nohide,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };
}
