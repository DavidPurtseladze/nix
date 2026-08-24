{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });

      # Every screenshot on this machine goes through the portal, and the
      # portal shells out to grim - xdg-desktop-portal-hyprland runs a
      # literal `grim '<tmpfile>'` for the whole desktop, with no
      # compression flag, so grim uses its default zlib level 6.
      #
      # On a 1920x1080 + 3440x1440 pair that is one 5360x1440 PNG, and
      # measured on this machine the encode alone costs 1.49s - by far the
      # largest part of the delay between hitting the screenshot key and
      # the editor appearing. The capture itself is ~30ms; it is all zlib.
      #
      # Level 1 brings that to 0.31s for a file 23% larger (7.6M vs 6.2M),
      # which nothing ever keeps: the portal deletes it as soon as the
      # client has read it. Level 0 is faster still (0.05s) but writes 30M
      # per capture, which felt like a poor trade for another 0.26s.
      #
      # Done as an override rather than a PATH trick because the portal is
      # wrapped with grim's store path baked in, so it cannot be shadowed.
      # See ../home/features/desktop/flameshot.nix for the consumer.
      xdg-desktop-portal-hyprland = prev.xdg-desktop-portal-hyprland.override {
        grim = final.runCommand "grim-fast-compression" {
          nativeBuildInputs = [final.makeWrapper];
          # Keeps `grim` usable as a normal package elsewhere: passthru and
          # meta (notably mainProgram) survive the wrapping.
          inherit (prev.grim) meta;
        } ''
          mkdir -p $out/bin
          makeWrapper ${prev.grim}/bin/grim $out/bin/grim --add-flags "-l 1"
        '';
      };
    };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
