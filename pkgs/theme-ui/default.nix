{
  writeShellApplication,
  procps,
  quickshell,
  theme-switcher,
}:
writeShellApplication {
  name = "theme-ui";

  runtimeInputs = [quickshell theme-switcher procps];

  text = ''
    state="''${XDG_STATE_HOME:-$HOME/.local/state}/theme"
    mkdir -p "$state"
    theme palettes "$@" > "$state/palettes.json"
    if pkill -f "quickshell -p ${./qml}"; then exit 0; fi

    exec quickshell -p ${./qml}
  '';
}
