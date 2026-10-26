{...}: {
  programs.zsh.enable = true;

  # xfconf daemon, required by Thunar for saving its settings
  programs.xfconf.enable = true;

  # needed for printing from machine
  services.printing.enable = true;

  # Per-host networking (extraHosts, trustedInterfaces) stays per-host.
  virtualisation.docker.enable = true;
}
