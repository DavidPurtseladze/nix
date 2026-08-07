{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./rofi.nix
      ./swaync.nix
      ./matugen.nix
      ./hyprpaper.nix
    ];

    home.packages = with pkgs; [

    ];
}
