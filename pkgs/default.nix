{ pkgs, ... }:
{
  # Define your custom packages here
  #  my-package = pkgs.callPackage ./my-package {};

  # Not in nixpkgs - see the comment at the top of ./iptvnator.
  iptvnator = pkgs.callPackage ./iptvnator {};

  theme-switcher = pkgs.callPackage ./theme-switcher {};

  wallpaper-ui = pkgs.callPackage ./wallpaper-ui {};

  theme-ui = pkgs.callPackage ./theme-ui {};

  notch = pkgs.callPackage ./notch {};
}
