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
  xdg.configFile."waybar/colors.css".text = ''
    @define-color background #1e1e2e;
    @define-color primary #bd93f9;
    @define-color primary_fixed #9580ff;
    @define-color secondary #f8f8f2;
    @define-color outline #6272a4;
    @define-color surface_container #282a36;
    @define-color inverse_surface #f8f8f2;
  '';

  programs.waybar = {
    enable = true;
    style = ./lib/wayland/style/islands.css;

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
    slurp

    pavucontrol
    playerctl
    qt6.qtwayland
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    wtype
    ydotool
  ] ++ import ./lib/scripts { inherit pkgs; };
};
}
