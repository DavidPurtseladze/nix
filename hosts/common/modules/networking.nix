# NetworkManager, sshd, and the firewall port sshd needs.
{pkgs, ...}: {
  networking.networkmanager.enable = true;

  # OpenVPN support in the NetworkManager applet/settings GUI.
  networking.networkmanager.plugins = [pkgs.networkmanager-openvpn];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings.PermitRootLogin = "no";
  };

  networking.firewall.allowedTCPPorts = [22];
}
