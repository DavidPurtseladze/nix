{
  config,
  lib,
  ...
}:
with lib; let
  root = "/etc/nixos/config";

  # TODO: drop this special case once hypridle/hyprlock move out of ~/.config/hypr.
  nested = ["hypr"];

  dirs = subtractLists nested (attrNames (filterAttrs (_: type: type == "directory") (builtins.readDir ../../config)));
in {
  xdg.configFile =
    genAttrs dirs (name: {
      source = config.lib.file.mkOutOfStoreSymlink "${root}/${name}";
    })
    // {
      "hypr/modules".source = config.lib.file.mkOutOfStoreSymlink "${root}/hypr/modules";
    };
}
