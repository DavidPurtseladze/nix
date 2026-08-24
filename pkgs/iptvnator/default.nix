# IPTVnator - Electron IPTV player (M3U/M3U8 playlists, Xtream Codes, EPG).
#
# Packaged here rather than taken from nixpkgs because it is not in nixpkgs at
# all - there is no `iptvnator` attribute in nixos-unstable.
#
# Upstream ships a .deb, an .rpm, a snap, a flatpak and an AppImage. The
# AppImage is the one that fits Nix best: appimageTools already knows how to
# unpack it and re-point the bundled Electron's interpreter and RPATH at the
# store, so nothing here has to chase the Chromium dependency list by hand.
{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}: let
  pname = "iptvnator";
  version = "0.22.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/4gray/iptvnator/releases/download/v${version}/iptvnator-${version}-linux-x86_64.AppImage";
      hash = "sha256-c+A6h2s6aKsUTmEtXqbV5/8i5gPBn+KGKH+aI25JdhY=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/4gray/iptvnator/releases/download/v${version}/iptvnator-${version}-linux-arm64.AppImage";
      hash = "sha256-bjbJVt/ChetU8qvJNja6uLmw4HFINoZpwYvvdfhkPY8=";
    };
  };

  # `or` rather than a bare lookup so that evaluating this package on an
  # unsupported system (the flake exports packages for darwin too) fails at
  # build time via meta.platforms instead of throwing during evaluation.
  src = srcs.${stdenv.hostPlatform.system} or srcs.x86_64-linux;

  # The AppImage carries its own .desktop file and icon set, but they live
  # inside the image where nothing on the system can see them. Unpacking a
  # second copy is the standard way to lift them out.
  contents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${contents}/${pname}.desktop \
        -t $out/share/applications

      # Two edits to the upstream entry:
      #
      # Exec=AppRun points at the AppImage's internal entrypoint, which does
      # not exist once wrapType2 has unpacked it - the launcher on PATH is
      # $out/bin/${pname}.
      #
      # --ozone-platform=x11 is upstream forcing XWayland. An explicit
      # --ozone-platform flag beats ELECTRON_OZONE_PLATFORM_HINT, so leaving
      # it in would make this the one Electron app on the host that ignores
      # the hint set in home/features/desktop/hyprland.nix and renders
      # blurry on the 3440x1440 panel.
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --ozone-platform=x11 %U' 'Exec=${pname} %U'

      for icon in ${contents}/usr/share/icons/hicolor/*/apps/${pname}.png; do
        size=$(basename $(dirname $(dirname "$icon")))
        install -Dm444 "$icon" \
          "$out/share/icons/hicolor/$size/apps/${pname}.png"
      done
    '';

    meta = {
      description = "Video player application that works with m3u and m3u8 playlists";
      homepage = "https://github.com/4gray/iptvnator";
      license = lib.licenses.mit;
      mainProgram = "iptvnator";
      platforms = builtins.attrNames srcs;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
