{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./hyprpaper.nix
    ];

    home.packages = with pkgs; [

    ];
}
