# Greeter and lock screen. theme is mkDefault so a host can override it.
{lib, ...}: {
  programs.qylock = {
    enable = true;
    theme = lib.mkDefault "sword";
    sddm.enable = true;
    quickshell.enable = true;
  };

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
}
