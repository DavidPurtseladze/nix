{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.misc;
in {
  options.features.cli.misc = {
    eza.enable = mkEnableOption "eza (ls replacement)";
    bat.enable = mkEnableOption "bat (cat replacement)";
    zoxide.enable = mkEnableOption "zoxide (cd replacement)";
    extras.enable = mkEnableOption "extra CLI utilities (fd, ripgrep, jq, htop, etc.)";
  };

  config = mkMerge [
    (mkIf cfg.eza.enable {
      programs.eza = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        extraOptions = [
          "-l"
          "--icons"
          "--git"
          "-a"
          "--header"
        ];
      };
    })

    (mkIf cfg.bat.enable {
      programs.bat.enable = true;
    })

    (mkIf cfg.zoxide.enable {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    })

    (mkIf cfg.extras.enable {
      home.packages = with pkgs; [
        coreutils
        fd
        htop
        httpie
        jq
        procs
        ripgrep
        tldr
        unzip
        zip
      ];
    })
  ];
}
