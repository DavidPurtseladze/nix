{
  writeShellApplication,
  quickshell,
  awww,
  theme-switcher,
}:
writeShellApplication {
  name = "wallpaper-ui";

  runtimeInputs = [quickshell awww theme-switcher];

  # "wallpaper-ui" opens the picker; "wallpaper-ui random" picks for you.
  text = ''
    dir="/etc/nixos/config/assets/wallpapers"

    if [ "''${1:-}" = "random" ]; then
      mapfile -t files < <(find "$dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \))
      [ ''${#files[@]} -eq 0 ] && exit 0
      path="''${files[RANDOM % ''${#files[@]}]}"
      awww img "$path" --transition-type grow --transition-pos top-left --transition-duration 1
      theme auto "$path"
      exit 0
    fi

    exec quickshell -p ${./qml} "$@"
  '';
}
