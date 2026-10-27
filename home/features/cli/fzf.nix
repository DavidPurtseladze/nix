{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.fzf;
in {
  options.features.cli.fzf.enable = mkEnableOption "Enable extended fzf configuration";

  config = mkIf cfg.enable {
    # Options live in config/fzf/fzfrc; colours come from theme-switcher.
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidget.command = "fd --type d --exclude .git --follow --hidden";
    };

    home.sessionVariables.FZF_DEFAULT_OPTS_FILE = "${config.xdg.configHome}/fzf/fzfrc";

    programs.zsh.initContent = mkAfter ''
      # Palette from theme-switcher; regenerated on every theme change.
      [ -r "''${XDG_STATE_HOME:-$HOME/.local/state}/theme/fzf-colors.sh" ] \
        && source "''${XDG_STATE_HOME:-$HOME/.local/state}/theme/fzf-colors.sh"

      # Pick a file and open it in nvim. Enter opens, ctrl-o prints the path.
      f() {
        fzf --bind 'enter:become(nvim {})' --bind 'ctrl-o:become(echo {})'
      }
    '';
  };
}
