# SoftEther VPN (staging) - CLI-only via vpncmd, no GUI on Linux.
# Account config lives in /var/lib/softether, not in this repo.
{
  config,
  lib,
  pkgs,
  ...
}: {
  services.softether.enable = true;
  services.softether.vpnclient.enable = true;

  systemd.services.vpnclient.serviceConfig = {
    ExecStart = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient start";
    ExecStop = lib.mkForce "${config.services.softether.dataDir}/vpnclient/vpnclient stop";
  };

  environment.systemPackages = with pkgs; [
    dhcpcd

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
}
