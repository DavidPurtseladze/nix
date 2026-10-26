{ pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  networking.hostName = "zero";

  # Off: xsessions/ is empty, so this only ever pulled in LightDM.
  services.xserver.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sized to RAM so hibernate has somewhere to write.
  swapDevices = [
    { device = "/swapfile"; size = 16384; }
  ];

  # Resolve host.docker.internal to docker
  networking.extraHosts = "127.0.0.1 host.docker.internal";

  # Let containers reach host services (e.g. MariaDB) past the firewall.
  networking.firewall.trustedInterfaces = ["docker0"];

  users.users."zero" = {
    isNormalUser = true;
    description = "Zero";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # Release of the first install; leave as-is.
  system.stateVersion = "26.05";
}
