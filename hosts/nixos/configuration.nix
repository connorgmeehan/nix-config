#your-hostname This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    ./cachix.nix

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Modular config
    ./modules/kanata.nix
    ./modules/nvidia.nix
    ./modules/android-dev.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # FIXME: Add the rest of your current configuration

  networking.hostName = "nixos";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use performance mode
  powerManagement.cpuFreqGovernor = "performance";

  # Kernel Modules
  boot.kernelModules = [ "uinput" "i2c-dev" "i2c-i801" ];

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Set the default shell to zsh
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cgm = {
    isNormalUser = true;
    description = "Connor Meehan";
    extraGroups = [ "networkmanager" "wheel" "config-man" "uinput" "libvirtd" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAGTHOh8SIE5IP77U4WuiNayAZ5xbyo8OkZmulRKFptfFJYBdoUWSt/Wb+B+eKcREaVMbai/7SCKSNwTu2A86Jg5ZJ80eddfJWDeLYkyJ8YSNc1TKe2eIhi29MqLmsJorHmbojeh6n3ebMOdewDMKgp1+EAIsUiino940rjzsDImSUonZz+LEnkfsY5kwxZFiD0HPL/5Xs82GvzJG2fyQtLICGjVw/fG4PjYkxTUMuSNLfav+DeXcaMkqEG7DUkNiXkfAJafRx1ViVk5E47soBEI0U3Q2ERduOSprIrqlhue4Lw7V8MGsEknbx6tuc2k7nrBTslmffgTgVWpFdzPTCC4EdZH4VSM6nd+YPXVLUYUJknt8WZSxJ8HWANo2XLwEsczeDvezp5x0evq0ox8ktoLxWFBphFs9JRwqPJlLKEHxhHALPUncaVHiByJmtZ2s3nwJJSWnh5Q4j84Ti6/En3630v2X5AgC1uHnQEszygut9L+SmjsjsXfdsRgmWNYE= connormeehan@Connors-MacBook-Pro.local"
    ];
    packages = with pkgs; [
      firefox
      git
      wget
      curl
    #  thunderbird
    ];
  };

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gcc
    clang
    rustup
    ripgrep
    gnome.zenity
    jq
    wmctrl
    xclip
    cachix

    gnome.gnome-boxes
    virt-manager

    escape-fsh

    protontricks

    mullvad-vpn
  ];

  ## PROGRAMS CONFIG
  programs.dconf.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.dzgui.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        mono # Cities skylines mods
      ];
    };
  };

  services.mullvad-vpn.enable = true;

  # Wayland support for new electron apps
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonPlatform --ozone-platform=wayland";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  networking.firewall.allowedTCPPortRanges = [
    { from = 5170; to = 5180; }
    { from = 8000; to = 9000; }
  ];


  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    settings.PasswordAuthentication = true;
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
    package = pkgs.openrgb-with-all-plugins;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

    # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" ]; })
  ];
}
