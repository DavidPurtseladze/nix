{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
      ./rofi.nix
      ./swaync.nix
      ./matugen.nix
    ];

    home.packages = with pkgs; [

    ];
}
