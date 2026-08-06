{
  config,
  lib,
  ...
}:
with lib;
let cfg = config.features.cli.lazydocker;
in {
  options.features.cli.lazydocker.enable = mkEnableOption "Enable lazydocker";

  config = mkIf cfg.enable {
    programs.lazydocker = {
      enable = true;

      settings = {
        gui = {
          theme = {
            activeBorderColor = [
              "#89b4fa"
              "bold"
            ];
            inactiveBorderColor = [
              "#6c7086"
            ];
            selectedLineBgColor = [
              "#313244"
            ];
            optionsTextColor = [
              "#89b4fa"
            ];
            defaultFgColor = [
              "#cdd6f4"
            ];
            searchingActiveBorderColor = [
              "#f9e2af"
            ];
          };
        };

        logs = {
          timestamps = true;
        };

        gui = {
          scrollHeight = 2;
          scrollPastBottom = true;
          tabWidth = 4;
        };
      };
    };
  };
}
