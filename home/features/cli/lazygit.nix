{
    config,
    lib,
    ...
}:
with lib;
let cfg = config.features.cli.lazygit;
in {
    options.features.cli.lazygit.enable = mkEnableOption "Enable lazygit";

    config = mkIf cfg.enable {
      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            theme = {
              activeBorderColor = [ "#89b4fa" "bold" ];
              inactiveBorderColor = [ "#6c7086" ];
              optionsTextColor = [ "#89b4fa" ];
              selectedLineBgColor = [ "#313244" ];
              selectedRangeBgColor = [ "#313244" ];
              cherryPickedCommitBgColor = [ "#94e2d5" ];
              cherryPickedCommitFgColor = [ "#89b4fa" ];
              unstagedChangesColor = [ "#f38ba8" ];
              defaultFgColor = [ "#cdd6f4" ];
              searchingActiveBorderColor = [ "#f9e2af" ];
            };
          };
          git = {
            overrideGpg = true;
          };
        };
      };
    };
}
