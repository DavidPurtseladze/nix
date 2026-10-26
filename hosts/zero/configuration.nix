# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "zero"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # OpenVPN support in the NetworkManager applet/settings GUI.
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  # SoftEther VPN client (staging VPN access) - CLI-managed via vpncmd,
  # there is no GUI "Client Manager" on Linux like on Windows.
  services.softether.enable = true;
  services.softether.vpnclient.enable = true;
  systemd.services.vpnclient.serviceConfig = {
    ExecStart = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient start";
    ExecStop = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient stop";
  };

  # Off: xsessions/ is empty, so this only ever pulled in LightDM.
  services.xserver.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Swap file on / (NVMe SSD per hardware-configuration.nix) - sized to RAM
  # (16GB) so hibernate has somewhere to write the memory snapshot.
  swapDevices = [
    { device = "/swapfile"; size = 16384; }
  ];

  # Resolve host.docker.internal to docker
  networking.extraHosts = "127.0.0.1 host.docker.internal";

  # Let containers reach host services (e.g. MariaDB) past the firewall.
  networking.firewall.trustedInterfaces = ["docker0"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."zero" = {
    isNormalUser = true;
    description = "Zero";
    # "docker" lets zero run docker commands without sudo.
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    dhcpcd

    # Multimedia backends for qylock's video themes; see QT_PLUGIN_PATH below.
    qt6.qtmultimedia

    (writeShellApplication {
      name = "vpn-up";
      runtimeInputs = [ config.services.softether.package systemd networkmanager dhcpcd iproute2 gnugrep gnused coreutils ];
      text = ''
        if [ "$(id -u)" -ne 0 ]; then exec sudo "$0" "$@"; fi

        systemctl is-active --quiet vpnclient || systemctl start vpnclient

        session_status() {
          vpncmd /CLIENT localhost /CMD AccountStatusGet staging \
            | grep '^Session Status' | cut -d'|' -f2 | sed 's/^ *//;s/ *$//' || true
        }

        vpncmd /CLIENT localhost /CMD AccountConnect staging >/dev/null || true

        established=
        for _ in $(seq 1 20); do
          case "$(session_status)" in
            *"Session Established"*) established=1; break ;;
          esac
          sleep 1
        done

        if [ -z "$established" ]; then
          echo "vpn-up: session not established"
          tail -n 5 /var/lib/softether/vpnclient/client_log/*.log 2>/dev/null || true
          exit 1
        fi

        if ! ip -br addr show vpn_vpn | grep -qE 'inet [0-9]'; then
          nmcli device set vpn_vpn managed no >/dev/null 2>&1 || true
          dhcpcd -4 --noipv4ll --timeout 25 vpn_vpn || true
        fi

        echo "vpn-up: connected"
        ip -br addr show vpn_vpn
        ip route show dev vpn_vpn
      '';
    })

    (writeShellApplication {
      name = "vpn-down";
      runtimeInputs = [ config.services.softether.package dhcpcd iproute2 ];
      text = ''
        if [ "$(id -u)" -ne 0 ]; then exec sudo "$0" "$@"; fi
        dhcpcd -k vpn_vpn >/dev/null 2>&1 || true
        vpncmd /CLIENT localhost /CMD AccountDisconnect staging >/dev/null || true
        echo "vpn-down: disconnected"
      '';
    })

    (writeShellApplication {
      name = "vpn-status";
      runtimeInputs = [ config.services.softether.package iproute2 ];
      text = ''
        vpncmd /CLIENT localhost /CMD AccountStatusGet staging | tail -n +7
        ip -br addr show vpn_vpn 2>/dev/null || true
      '';
    })
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

  # Greeter and lock screen, same theme for both.
  programs.qylock = {
    enable = true;
    theme = "sword";
    sddm.enable = true;
    quickshell.enable = true;
  };

  # Wayland greeter; qylock sets .theme for us.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Pin the plain session; uwsm fights the units hyprland.lua starts itself.
  services.displayManager.defaultSession = "hyprland";

  # The qylock module ships no PAM service of its own.
  security.pam.services.qylock = {};

  # qylock's wrapper omits this, so Qt finds no media backend; env.lua sets it too.
  environment.sessionVariables.QT_PLUGIN_PATH = "/run/current-system/sw/lib/qt-6/plugins";

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
