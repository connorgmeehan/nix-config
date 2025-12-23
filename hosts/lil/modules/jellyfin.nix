{ pkgs, config, ... }: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "connorgm";
  };

  # Acceleration

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD"; # or i965 for older GPUs
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-ocl # Generic OpenCL support

      intel-media-driver
      # For 13th gen and newer:
      intel-compute-runtime
    ];
  };
  # On Intel N100 CPUs, enable firmware loading to prevent GuC errors: 
  hardware.enableAllFirmware = true;

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
