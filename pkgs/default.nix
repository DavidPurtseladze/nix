{ pkgs, ... }:
{
  # Define your custom packages here
  #  my-package = pkgs.callPackage ./my-package {};

  # Not in nixpkgs - see the comment at the top of ./iptvnator.
  iptvnator = pkgs.callPackage ./iptvnator {};
}
