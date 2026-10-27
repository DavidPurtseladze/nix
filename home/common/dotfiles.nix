{
  config,
  lib,
  ...
}:
with lib; let
  root = "/etc/nixos/config";

  # Every top-level entry of config/ is linked at the same name under
  # ~/.config, directories and loose files alike.
  entries = attrNames (builtins.readDir ../../config);
in {
  xdg.configFile = genAttrs entries (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${root}/${name}";
  });
}
