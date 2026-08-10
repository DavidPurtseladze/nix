/*
  General/decoration/layout tuning. Mirrors the source repo's
  configs/looknfeel.conf.
*/
{
  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    "col.active_border" = "rgba(9742b5ee) rgba(9742b5ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    rounding_power = 2;
    active_opacity = 1.0;
    inactive_opacity = 0.8;

    shadow = {
      enabled = false;
      range = 4;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = true;
      size = 5;
      passes = 3;
      ignore_opacity = true;
      new_optimizations = true;
      special = false;
      popups = true;
      xray = true;
      vibrancy = 0.1696;
    };
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    vfr = true;
  };
}
