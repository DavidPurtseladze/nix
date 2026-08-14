{
    config,
    lib,
    pkgs,
    ...
}:
with lib; 
let cfg = config.features.cli.fastfetch;
in {
    options.features.cli.fastfetch.enable = mkEnableOption "Enable fastfetch";

    config = mkIf cfg.enable {
        programs.fastfetch = {
            enable = true;

            settings = {
                logo = {
                    source = "nixos_small";
                    padding = {
                        right = 1;
                    };
                };
            };
        };
    };
}