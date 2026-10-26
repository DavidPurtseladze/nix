{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  networking.hostName = "nik-a73";

  # Sized to RAM so hibernate has somewhere to write.
  swapDevices = [
    { device = "/swapfile"; size = 16384; }
  ];

  users.users."nik-a73" = {
    isNormalUser = true;
    description = "nik-a73";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # NixOS options, not home-manager packages: the GUI needs a setuid helper
  # and /etc/1password that a user-profile install cannot create.
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nik-a73" ];
  };

  # Single-GPU desktop; both displays hang off the 4070 SUPER.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # No default above driver 560; eval fails without it.
    open = true;

    # Preserves VRAM across suspend; without it the GPU resumes with garbage
    # shader state and Hyprland dies on its first frame (NVRM: Xid 13).
    powerManagement.enable = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

  # The nvidia module only adds these when services.xserver.enable is true.
  # Without nvidia_drm there is no framebuffer, i.e. a black screen at tuigreet.
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

  # 32-bit driver stack for Steam's runtime and older games.
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Lets games request the performance governor while they run.
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  # Release of the first install; leave as-is.
  system.stateVersion = "26.05";
}
