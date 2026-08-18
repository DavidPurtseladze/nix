# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nik-a73"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ka_GE.UTF-8";
    LC_IDENTIFICATION = "ka_GE.UTF-8";
    LC_MEASUREMENT = "ka_GE.UTF-8";
    LC_MONETARY = "ka_GE.UTF-8";
    LC_NAME = "ka_GE.UTF-8";
    LC_NUMERIC = "ka_GE.UTF-8";
    LC_PAPER = "ka_GE.UTF-8";
    LC_TELEPHONE = "ka_GE.UTF-8";
    LC_TIME = "ka_GE.UTF-8";
  };

  # Wayland-native greeter (greetd + tuigreet).
  #
  # Previously this host set services.xserver.enable, which pulled in LightDM
  # and Xorg as the default display manager. That bought nothing: the only
  # session installed here is hyprland.desktop under share/wayland-sessions,
  # and share/xsessions is empty - so Xorg existed purely to hand off to a
  # Wayland compositor.
  #
  # That handoff raced with udev. display-manager.service was ordered only
  # after systemd-user-sessions.service (reached at ~3s), while the USB
  # keyboard and mouse do not finish enumerating and get their ID_INPUT_*
  # udev tags until ~5.7s. Nothing forced the greeter to wait for them, so a
  # session could come up with libinput binding no input devices at all
  # ("not using input device '/dev/input/event0'"), leaving keyboard and
  # mouse dead until they were physically replugged - a replug re-emits the
  # udev add events that the running compositor then picks up.
  #
  # greetd starts the compositor directly on a VT with no Xorg in between,
  # and Hyprland is launched only after a human has logged in, by which point
  # udev has long since settled.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  # Bluetooth + blueman GUI manager (NixOS-only options, can't be set from home-manager).
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Swap file on / (NVMe SSD per hardware-configuration.nix) - sized to RAM
  # (16GB) so hibernate has somewhere to write the memory snapshot.
  swapDevices = [
    { device = "/swapfile"; size = 16384; }
  ];

  # Required for hyprlock to actually authenticate - without this, typing
  # your password on the lock screen never unlocks anything (PAM has no
  # service file for hyprlock to validate against).
  security.pam.services.hyprlock = {};

  # Enable Docker   
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."nik-a73" = {
    isNormalUser = true;
    description = "nik-a73";
    # "docker" lets nik-a73 run docker commands without sudo.
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # 1Password (GUI + `op` CLI).
  #
  # These have to be NixOS options rather than a home-manager package: the
  # desktop app ships a setuid-root helper (1Password-BrowserSupport) and
  # relies on a /etc/1password/custom_allowed_browsers list, neither of which
  # a user-profile install can create. Without the module you get an app that
  # refuses to talk to the browser extension and can't unlock via polkit.
  #
  # polkitPolicyOwners is who may authenticate to 1Password with their system
  # password / fingerprint instead of retyping the master password.
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nik-a73" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # NVIDIA (GeForce RTX 4070 SUPER).
  #
  # Both connected displays hang off the discrete card (card0-DP-4 and
  # card0-HDMI-A-4 on 01:00.0); the Intel UHD 770 iGPU has no connected
  # outputs. So this is a plain single-GPU desktop - no PRIME offload or
  # sync, which is only needed when the iGPU drives the panel.
  #
  # Without this the kernel falls back to nouveau, which cannot reclock Ada
  # cards: the GPU stays pinned near its boot clocks, so you get a fraction
  # of the card's performance and no usable Vulkan.
  #
  # Setting videoDrivers is what wires the driver up even on Wayland - the
  # NixOS module keys off it to install the kernel module, the libglvnd
  # vendor files (including the 32-bit ones for Steam) and the udev rules,
  # and to blacklist nouveau.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Required for any Wayland compositor. On driver 545+ this also passes
    # nvidia-drm.modeset=1 and nvidia-drm.fbdev=1, so the card provides its
    # own framebuffer device - that is what gives greetd/tuigreet a usable
    # console on these outputs before Hyprland ever starts.
    modesetting.enable = true;

    # Ada is fully supported by the open kernel modules, and they are what
    # NVIDIA develops against from 560 onwards. Not optional to omit: the
    # module has no default for this above 560 and eval fails without it.
    #
    # This also turns on powerManagement.kernelSuspendNotifier by default
    # (open modules + driver >= 595), which lets the driver handle
    # suspend/hibernate through the kernel rather than through the older
    # VRAM save/restore systemd services.
    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # The nvidia-settings GUI, for fan curves and per-display config.
    nvidiaSettings = true;
  };

  # Load the display-side modules at boot ourselves.
  #
  # The nvidia module only adds these to boot.kernelModules when
  # services.xserver.enable is true, and this host deliberately runs no
  # Xorg (see the greetd comment above). Only nvidia_uvm ends up eager,
  # which pulls in nvidia but not nvidia_modeset or nvidia_drm - and
  # nvidia_drm.ko carries no PCI modalias, so udev will not autoload it
  # either. Without it there is no DRM device and no framebuffer on the
  # NVIDIA outputs, which is a black screen at tuigreet.
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

  # Steam.
  #
  # This has to be a NixOS option rather than a home-manager package: the
  # module sets up the FHS environment Steam needs (it ships prebuilt
  # binaries that expect /lib, /usr/lib and friends), pulls in the 32-bit
  # driver stack, and installs the udev rules for Steam Input controllers.
  #
  # enable32Bit is what makes hardware acceleration work for the many
  # 32-bit games and for Steam's own runtime; without it they fall back to
  # software rendering or fail to start. hardware.graphics.enable itself is
  # already turned on by programs.hyprland above.
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
    # Opens 27031-27036/UDP+TCP for streaming to another machine on the LAN.
    remotePlay.openFirewall = true;
    # Opens 27015-27020 for hosting Source-engine dedicated servers.
    dedicatedServer.openFirewall = true;
    # Steam's own compositor - gives per-game resolution/upscaling and
    # fixes fullscreen behaviour under Hyprland.
    gamescopeSession.enable = true;
  };

  # Lets games ask the kernel for the performance CPU governor and higher
  # I/O priority while they run, and drop back afterwards.
  programs.gamemode.enable = true;

  # xfconf daemon, required by Thunar for saving its settings
  programs.xfconf.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings.PermitRootLogin = "no";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enables screen sharing and file picker dialogs under Hyprland.
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["hyprland" "gtk"];
  };

  programs.zsh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
