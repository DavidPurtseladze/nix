{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  networking.hostName = "zero";

  # SoftEther VPN (staging) - CLI-only via vpncmd, no GUI on Linux.
  services.softether.enable = true;
  services.softether.vpnclient.enable = true;
  systemd.services.vpnclient.serviceConfig = {
    ExecStart = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient start";
    ExecStop = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient stop";
  };

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

  environment.systemPackages = with pkgs; [
    dhcpcd

    # Media backends for qylock's video themes; see QT_PLUGIN_PATH below.
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

  # Release of the first install; leave as-is.
  system.stateVersion = "26.05";

}
