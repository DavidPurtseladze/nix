/*
  Autostart + environment variables. Mirrors the "AUTOSTART"/"ENVIRONMENT
  VARIABLES" sections of the source repo's hyprland.conf.
*/
{
  xwayland = {
    force_zero_scaling = true;
  };

  # waybar is intentionally NOT here: programs.waybar.systemd.enable = true
  # (wayland.nix) already starts it as a systemd user service. Having it
  # in both places spawns two competing waybar processes / two bars.
  exec-once = [
    "hyprpaper"
    "hypridle"
    "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""
  ];

  env = [
    "XCURSOR_SIZE,32"
    "WLR_NO_HARDWARE_CURSORS,1"
    "GTK_THEME,Dracula"
  ];
}
