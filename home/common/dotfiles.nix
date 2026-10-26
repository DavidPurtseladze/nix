{
  config,
  lib,
  ...
}:
with lib; let
  root = "/etc/nixos/config";

  dirs = attrNames (filterAttrs (_: type: type == "directory") (builtins.readDir ../../config));
in {
  xdg.configFile = genAttrs dirs (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${root}/${name}";
  });
}
