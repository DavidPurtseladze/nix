/*
  Mirrors the source repo's configs/keybinds.conf.
*/
{
  "$mainMod" = "SUPER";

  bind = [
    "$mainMod, return, exec, kitty -e zellij-ps"
    "$mainMod SHIFT, return, exec, [float; size 800 550] kitty"
    "$mainMod, t, exec, kitty -e zsh -c 'fastfetch; exec zsh'"
    "$mainMod SHIFT, e, exec, kitty -e zellij_nvim"
    "$mainMod, o, exec, thunar"
    "$mainMod, Escape, exec, wlogout -p layer-shell"
    "$mainMod, Space, togglefloating"
    "$mainMod, q, killactive"
    "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
    "$mainMod SHIFT, q, exec, hyprctl kill"
    "$mainMod, M, exit"
    "$mainMod, F, fullscreen"
    "$mainMod, V, togglefloating"
    "$mainMod, D, exec, rofi -show drun"
    "$mainMod, B, exec, xdg-open \"https://\""
    "$mainMod, L, exec, hyprlock"
    "$mainMod, C, exec, hyprpicker -a"
    "$mainMod, R, exec, systemctl --user restart waybar.service"
    "$mainMod, H, exec, pkill -SIGUSR1 waybar"
    "$mainMod, S, exec, mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy"
    "$mainMod SHIFT, T, exec, matugen-apply"
    "$mainMod SHIFT, S, exec, bemoji"
    "$mainMod, P, exec, wofi-pass"
    "$mainMod SHIFT, P, pseudo"
    "$mainMod, J, layoutmsg, togglesplit"
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod CTRL, left, movewindow, l"
    "$mainMod CTRL, right, movewindow, r"
    "$mainMod CTRL, up, movewindow, u"
    "$mainMod CTRL, down, movewindow, d"
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
  ];

  binde = [
    "$mainMod SHIFT, left, resizeactive, -50 0"
    "$mainMod SHIFT, right, resizeactive, 50 0"
    "$mainMod SHIFT, up, resizeactive, 0 -50"
    "$mainMod SHIFT, down, resizeactive, 0 50"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  # ,-prefixed = no modifier: laptop multimedia keys.
  bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
  ];

  # bindl = fires on both press and release; used for media keys so they
  # still work while a lockscreen/inhibitor eats normal binds.
  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
  ];
}
