/*
  Mirrors the source repo's configs/windowrules.conf + tags.conf (Hyprland
  here has no "tags" step - those rules just match by class directly).
*/
{
  # windowrule/windowrulev2 both accepted (v2 is the modern syntax; kept
  # separate below only where the older short form was already in use).
  windowrule = [
    "float, file_progress"
    "float, confirm"
    "float, dialog"
    "float, download"
    "float, notification"
    "float, error"
    "float, splash"
    "float, confirmreset"
    "float, title:Open File"
    "float, title:branchdialog"
    "float, Lxappearance"
    "float, dunst"
    "float,viewnior"
    "float,feh"
    "float, pavucontrol-qt"
    "float, pavucontrol"
    "float, file-roller"
    "fullscreen, wlogout"
    "float, title:wlogout"
    "fullscreen, title:wlogout"
    "idleinhibit focus, mpv"
    "idleinhibit fullscreen, firefox"
    "float, title:^(Media viewer)$"
    "float, title:^(Volume Control)$"
    "float, title:^(Picture-in-Picture)$"
    "size 800 600, title:^(Volume Control)$"
    "move 75 44%, title:^(Volume Control)$"

    # Popups/dialogs
    "float, title:^(Save As|Save a File|Pick Files)$"
    "size 50% 60%, title:^(Save As|Save a File|Pick Files)$"
    "center, title:^(Save As|Save a File|Pick Files)$"
    "float, initialTitle:(Open Files)"
    "size 70% 60%, initialTitle:(Open Files)"

    # Ignore maximize requests from apps
    "suppressevent maximize, class:.*"
    # Fix XWayland drag-and-drop focus stealing
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
  ];

  layerrule = [
    "blur, waybar"
    "ignorealpha 0.5, waybar"
    "blur, logout_dialog"
    "blur, swaync-control-center"
    "blur, swaync-notification-window"
    "ignorezero, swaync-control-center"
    "ignorezero, swaync-notification-window"
    "ignorealpha 0.5, swaync-control-center"
    "ignorealpha 0.5, swaync-notification-window"
    "xray 0, swaync-control-center"
    "xray 0, swaync-notification-window"
  ];

  windowrulev2 = [
    "workspace 1,class:(Emacs)"
    "workspace 3,opacity 1.0, class:(brave-browser)"
    "workspace 4,class:(com.obsproject.Studio)"

    # Tag-then-rule pairs ported from the source repo (Hyprland doesn't
    # have "tags" here so these just match by class directly)
    "noblur, class:^([Mm]pv|vlc)$"
    "opacity 1.0, class:^([Mm]pv|vlc)$"
    "float, class:^([Mm]pv|vlc)$"
    "size 900 506, class:^([Mm]pv|vlc)$"
    "opacity 0.9, class:^(kitty)$"
  ];
}
