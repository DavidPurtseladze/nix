{
config,
lib,
pkgs,
...
}:
with lib; let
cfg = config.features.desktop.wayland;
in {
options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

config = mkIf cfg.enable {
  programs.waybar = {
    enable = true;
    style = ''
    '';

    settings = {
      mainbar = {
        layer = "bottom";
        exclusive = true;
        passthrough = false;
        position = "top";
        spacing = 3;
        fixed-center = true;
        ipc = true;
        margin-top = 5;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "clock"
          "custom/separator#blank"
          "tray"
          "custom/separator#blank"
          "hyprland/workspaces#kanji"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "group/notify"
          "custom/separator#blank"
          "battery"
          "custom/separator#blank"
          "group/audio"
          "custom/separator#blank"
          "custom/power"
        ];
      }

      // import ./lib/wayland/workspaces.nix
      // import ./lib/wayland/custom.nix
      // import ./lib/wayland/modules.nix
      // import ./lib/wayland/groups.nix;
    };
  };

  home.packages = with pkgs; [
    grim
    hyprlock
    pavucontrol
    playerctl
    qt6.qtwayland
    slurp
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    wtype
    ydotool
  ] ++ import ./lib/scripts { inherit pkgs; };
};
}
