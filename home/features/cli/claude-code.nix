{
    config,
    lib,
    pkgs,
    ...
}:
with lib;
let cfg = config.features.cli.claude-code;
in {
    options.features.cli.claude-code.enable = mkEnableOption "Enable Claude Code";

    config = mkIf cfg.enable {
        home.packages = with pkgs; [claude-code];
    };
}
 
