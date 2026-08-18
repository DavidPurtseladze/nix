{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./awww.nix
      ./wlogout.nix
      ./rofi.nix
      ./hyprlock.nix
      ./hypridle.nix
      ./swaync.nix
      ./thunar.nix
      ./gtk.nix
      ./cursor.nix
      ./media.nix
    ];

    home.packages = with pkgs; [

    ];
}
