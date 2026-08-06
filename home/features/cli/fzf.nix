{
    config,
    lib,
    ...
}:
with lib; 
let cfg = config.features.cli.fzf;
in {
    options.features.cli.fzf.enable = mkEnableOption "Enable extended fzf configuration";

    config = mkIf cfg.enable {
        programs.fzf = {
            enable = true;
            enableZshIntegration = true;

            colors = {
                "fg" = "#abb2bf";
                "bg" = "#282c34";
                "hl" = "#61afef";

                "fg+" = "#e6edf3";
                "bg+" = "#3e4451";
                "hl+" = "#61afef";

                "info" = "#e5c07b";
                "prompt" = "#98c379";
                "pointer" = "#c678dd";
                "marker" = "#c678dd";
                "spinner" = "#e5c07b";
                "header" = "#56b6c2";
            };

            defaultOptions = [
                "--preview='bat --color=always -n {}'"
                "--bind 'ctrl-/:toggle-preview'"
            ];

            defaultCommand = "fd -type f --exclude .git --follow --hidden";
            changeDirWidget.command = "fd --type d --exclude .git --follow --hidden";
        };
    };
}