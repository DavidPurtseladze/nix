{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./hyprpaper.nix
      ./wlogout.nix
      ./rofi.nix
      ./hyprlock.nix
      ./swaync.nix
    ];

    home.packages = with pkgs; [

    ];
}
