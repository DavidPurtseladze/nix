{
  writeShellApplication,
  quickshell,
  theme-switcher,
}:
writeShellApplication {
  name = "theme-ui";

  runtimeInputs = [quickshell theme-switcher];

  text = ''
    state="''${XDG_STATE_HOME:-$HOME/.local/state}/theme"
    mkdir -p "$state"
    theme palettes "$@" > "$state/palettes.json"
    exec quickshell -p ${./qml}
  '';
}
