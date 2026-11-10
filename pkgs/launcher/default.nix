{
  writeShellApplication,
  quickshell,
  material-symbols,
  libqalculate,
  cliphist,
  theme-switcher,
  wl-clipboard,
}:
writeShellApplication {
  name = "launcher";
  runtimeInputs = [quickshell libqalculate wl-clipboard cliphist theme-switcher];
  text = ''
    export LAUNCHER_ICON_FONT="${material-symbols}/share/fonts/truetype/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
    config=${./.}

    case "''${1:-}" in
      toggle | open | close)
        if ! quickshell ipc -p "$config" call launcher "$1" >/dev/null 2>&1; then
          [ "$1" = close ] && exit 0
          LAUNCHER_OPEN=1 exec quickshell -p "$config" -d
        fi
        ;;
      clipboard)
        if ! quickshell ipc -p "$config" call launcher clipboard >/dev/null 2>&1; then
          LAUNCHER_OPEN=1 LAUNCHER_TEXT=">clip " exec quickshell -p "$config" -d
        fi
        ;;
      "")
        exec quickshell -p "$config"
        ;;
      *)
        echo "usage: launcher [toggle|open|close|clipboard]" >&2
        exit 1
        ;;
    esac
  '';
}
