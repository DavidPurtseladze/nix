{pkgs, ...}: let
  script = name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      bashOptions = ["nounset" "pipefail"];
      text = builtins.readFile ./${name}.sh;
    };
in [
  (script "volume" [pkgs.wireplumber pkgs.gawk pkgs.gnugrep pkgs.libnotify])
  (script "brightness" [pkgs.brightnessctl pkgs.gawk pkgs.libnotify])
  (script "night-mode" [pkgs.libnotify])
  (script "caffeine" [pkgs.libnotify])
]
