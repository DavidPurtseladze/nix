{
    config,
    lib,
    pkgs,
    ...
}:
with lib;
let
    cfg = config.features.cli.tmux;
in {
    imports = [../../../config/tmux/plugins.nix];

    options.features.cli.tmux.enable = mkEnableOption "Enable Tmux; config lives in config/tmux";

    config = mkIf cfg.enable {
        home.packages = [pkgs.tmux];
    };
}
