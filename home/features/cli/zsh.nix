{
    config,
    lib,
    pkgs,
    ...
}:
with lib; 
let cfg = config.features.cli.zsh;
in {
    options.features.cli.zsh.enable = mkEnableOption "Enable zsh and configure zsh";

    config = mkIf cfg.enable {
        programs.zsh = {
            enable = true;

            # enable plugins            
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            historySubstringSearch.enable = true;
            history = {
                size = 10000;
                save = 10000;
                share = true;
                ignoreDups = true;
                ignoreSpace = true;
            };

            initContent = ''
                export LS_COLORS="$(vivid generate catppuccin-mocha)"

                zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

                source ${pkgs.zsh-abbr}/share/zsh/zsh-abbr/abbr.plugin.zsh

                abbr -f grep='rg' >/dev/null
                abbr -f ls='eza --icons' >/dev/null
                abbr -f ll='eza -lah --icons' >/dev/null
            '';
        };
    };
}
