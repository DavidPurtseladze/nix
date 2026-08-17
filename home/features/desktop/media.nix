{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.media;
in {
  options.features.desktop.media.enable = mkEnableOption "Image (imv) and video (mpv) viewers";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      imv
      mpv
    ];

    xdg.mimeApps.defaultApplications = {
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";

      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";

      "application/pdf" = "zen-beta.desktop";
    };
  };
}
