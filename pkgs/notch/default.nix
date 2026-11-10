{
  writeShellApplication,
  quickshell,
}:
writeShellApplication {
  name = "notch";
  runtimeInputs = [quickshell];
  text = ''
    exec quickshell -p ${./.} "$@"
  '';
}
