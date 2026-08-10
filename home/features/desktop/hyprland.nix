{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  # Settings are split into ./hyprland/*.nix, one file per section, mirroring
  # the source repo's hypr/configs/*.conf split (env.nix ~ autostart/env in
  # hyprland.conf itself, input.nix ~ input.conf, looknfeel.nix ~
  # looknfeel.conf, animations.nix ~ UserAnimations.conf, windowrules.nix ~
  # windowrules.conf+tags.conf, keybinds.nix ~ keybinds.conf). Each file is
  # a plain attrset (not a module), so merging is a simple, predictable `//`
  # right here instead of relying on module-system merge semantics.
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings =
        import ./hyprland/env.nix
        // import ./hyprland/input.nix
        // import ./hyprland/looknfeel.nix
        // import ./hyprland/animations.nix
        // import ./hyprland/windowrules.nix
        // import ./hyprland/keybinds.nix;
    };
  };
}
