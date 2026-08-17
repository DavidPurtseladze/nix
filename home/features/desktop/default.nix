{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./hyprpaper.nix
      ./wlogout.nix
      ./rofi.nix
      ./hyprlock.nix
      ./hypridle.nix
      ./swaync.nix
      ./thunar.nix
      ./gtk.nix
      ./media.nix
    ];

    home.packages = with pkgs; [

    ];
}
