{pkgs, ...}: {
    imports = [
      ./wayland.nix
      ./hyprland.nix
      ./fonts.nix
    ];

    home.packages = with pkgs; [

    ];
}
